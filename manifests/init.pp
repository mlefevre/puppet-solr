
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

}
