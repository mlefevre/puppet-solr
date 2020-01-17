
# Class: solr
# ===========================
#
# Description of class solr here.
# This description aimed to deploy the old version 1.4.1 of Solr.
# Examples
# --------
#
# @example
#    class { 'solr':
#      version => '7.7.0',
#    }
#
# Authors
# -------
#
# Michael Strache <michael.strache@netcentric.biz>
# Valentin Savenko <valentin.savenko@netcentric.biz>
# Marc Lefèvre <mlefevre@cirb.brussels>
#


class solr (
  String  $user,
  String  $group,
  String  $install_dir,
  String  $service_name,
  String  $version,
  String  $archive_url,
  String  $archive_name,
  Integer $port,
  String  $memory,
  String  $data_dir,
) {

  #------------------------------------------------------------------------------#
  # Code                                                                         #
  #------------------------------------------------------------------------------#
  # So far based on https://lucene.apache.org/solr/guide/7_1/taking-solr-to-production.html#taking-solr-to-production



  # solr dependency on RedHat servers
  package { 'lsof':
    ensure => 'installed',
  }

  # Download the installer archive and extract the install script
  $install_archive = "${install_dir}/${archive_name}"
  archive { $install_archive:
    checksum_verify  => false,
    cleanup       => false,
    creates       => 'dummy_value', # extract every time. This is needed because archive has unexpected behaviour without it. (seems to be mandatory, instead of optional)
    extract       => true,
    extract_path  => $install_dir,
    source        => "${archive_url}/${archive_name}"
  }

  # Create instance data folder
  file { $data_dir:
    recurse => true,
    owner   => $user,
    group   => $group,
  }

  # Solr is extracted & installed here
  $home_dir = "${install_dir}/solr-${$version}"

  # triggers install script as defined in the solr docu
  $install_command = "${home_dir}/bin/install_solr_service.sh ${install_archive} -n -i ${install_dir} -d ${data_dir} -u ${user} -s ${service_name} -p ${port}"
  exec { "Solr install for Solr-${version}" :
        command => $install_command,
        timeout => 200,
        path    => '/usr/bin:/bin',
        unless  => "/usr/bin/test -e ${home_dir}/.solr-${version}-installed-flag",
        require => [
          File[$data_dir],
          Archive[$install_archive],
        ];
  }

  # Leave breadcrumbs/flags to indicate that the installation + restarts was already performed and should not be repeated next time!
  file { "Solr-${version} - Leave breadcrumbs to indicate that the Solr-${version} was already installed." :
    ensure  => present,
    path    => "${home_dir}/.solr-${version}-installed-flag",
    owner   => $user,
    mode    => '0644',
    content => "This file indicates that solr was already installed in this version and doesn\'t need to be repeated on every puppet run!",
    require => [
      Exec["Solr install for Solr-${version}"],
    ];
  }

  # default solr config file 
  $config_file = "/etc/default/${service_name}.in.sh"

  file { $config_file:
    ensure  => present,
    path    => $config_file,
    require => [
      Exec["Solr install for Solr-${version}"],
    ];
  }

  if $memory {
    file_line { 'Append memory setting to the default config file for the solr service':
      notify  => Service[$service_name],
      path    => $config_file,
      line    => "SOLR_JAVA_MEM=\"${memory}\"",
      match   => '.*SOLR_JAVA_MEM=.*',
      require => File[$config_file],

    }
  }

}
