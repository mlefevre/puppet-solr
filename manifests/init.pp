
# Class: solr
# ===========================
#
# Description of class solr here.
# This description aimed to deploy the Solr 1.4.1 provided with Alfresco 4.2
# 
# Solr will be deployed on an existing tomcat server.
# Examples
# --------
#
# @example
#    class { 'solr':
#      install_dir => 'tomcat/webapps'
#    }
#
# Authors
# -------
#
# Marc Lefèvre <mlefevre@cirb.brussels>
#


class solr (
  String  $user,
  String  $group,
  String  $install_dir,
  String  $archive_url,
  String  $archive_name,
) {

  #------------------------------------------------------------------------------#
  # Code                                                                         #
  #------------------------------------------------------------------------------#

  $install_archive = "${install_dir}/${archive_name}"
  # solr dependency on RedHat servers
  package { 'lsof':
    ensure => 'installed',
  }->
  file { "${install_dir}":
    ensure => directory,
    owner => $user,
    group => $group,
    mode => '0755',
  }->
  # Download and extract the alfresco archive
  archive { $install_archive:
    user          => $user,
    group         => $group,
    source        => "${archive_url}/${archive_name}",
    cleanup       => false,
    path          => "/tmp/${archive_name}",
    extract       => true,
    extract_path  => $install_dir,
    checksum_verify  => false,
  }->
  solr::solrcore {'archive':
    core_name => 'archive',
    user          => $user,
    group         => $group,
    install_dir => $install_dir	,
  }->
  solr::solrcore {'workspace':
    core_name => 'workspace',
    user          => $user,
    group         => $group,
    install_dir => $install_dir,
  }->
  file {"Remove default keystore":
    ensure => absent,
    recurse => true,
    purge => true,
    path => "${install_dir}/alf_data/keystore"
  }->
  file {"Remove default password files in workspace-SpaceStore":
    ensure =>absent,
    path => "${install_dir}/workspace-SpacesStore/conf/*passwords.properties"
  }->
  file {"Remove default password files in archive-SpaceStore":
    ensure =>absent,
    path => "${install_dir}/archive-SpacesStore/conf/*passwords.properties"
  }->
  file {"${install_dir}/workspace-SpacesStore/conf/ssl.repo.client.keystore":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      source => 'puppet:///modules/application/bosecr2/solr/ssl.repo.client.keystore'
  }->
  file {"${install_dir}/workspace-SpacesStore/conf/ssl-repo-client-keystore-passwords.properties":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      source => 'puppet:///modules/application/bosecr2/solr/ssl-repo-client-keystore-passwords.properties'
  }->
  file {"${install_dir}/workspace-SpacesStore/conf/ssl.repo.client.truststore":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      source => 'puppet:///modules/application/bosecr2/solr/ssl.repo.client.truststore'
  }->
  file {"${install_dir}/workspace-SpacesStore/conf/ssl-repo-client-truststore-passwords.properties":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      source => 'puppet:///modules/application/bosecr2/solr/ssl-repo-client-truststore-passwords.properties'
  }->
  file {"${install_dir}/archive-SpacesStore/conf/ssl.repo.client.keystore":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      source => 'puppet:///modules/application/bosecr2/solr/ssl.repo.client.keystore'
  }->
  file {"${install_dir}/archive-SpacesStore/conf/ssl-repo-client-keystore-passwords.properties":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      source => 'puppet:///modules/application/bosecr2/solr/ssl-repo-client-keystore-passwords.properties'
  }->
  file {"${install_dir}/archive-SpacesStore/conf/ssl.repo.client.truststore":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      source => 'puppet:///modules/application/bosecr2/solr/ssl.repo.client.truststore'
  }->
  file {"${install_dir}/archive-SpacesStore/conf/ssl-repo-client-truststore-passwords.properties":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      source => 'puppet:///modules/application/bosecr2/solr/ssl-repo-client-truststore-passwords.properties'
  }

}
