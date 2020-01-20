
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
#      version => '7.7.0',
#      install_dir => 'tomcat/webapps'
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

  # Download and extract the alfresco archive
  $install_archive = "${install_dir}/${archive_name}"
  archive { $install_archive:
    checksum_verify  => false,
    extract       => true,
    extract_path  => $install_dir,
    creates       => "${install_dir}",
    source        => "${archive_url}/${archive_name}",
    cleanup       => true,
  }->
  exec {"Configure workspace in solcore.proprerties":
    command => "sed -i -E 's|@@ALFRESCO_SOLR_DIR@@|${install_dir}|g' ${install_dir}/workspace-SpacesStore/conf/solrcore.properties ${install_dir}/data/archive-SpacesStore/conf/solrcore.properties"
  }->
  exec {"Configure truststore and keystore in solrcore.properties":
    command => "sed -i -E 's|=ssl-(.+)store|=ssl-repo-client-\1store|g' ${install_dir}/workspace-SpacesStore/conf/solrcore.properties ${install_dir}/archive-SpacesStore/conf/solrcore.properties"
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
#  }->
#  file {"Add keystore/truststore ...":
#    ensure => file,
#    content => "",
#    path => ""
  }

}
