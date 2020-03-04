define solr::solrcore(
  $core_name,
  $install_dir,
  $alfresco_host = "localhost",
  $alfresco_port = "8080",
  $alfresco_ssl_port = "8443",
  $alfresco_keystore_filename = "ssl.repo.client.keystore",
  $alfresco_keystore_pwd_file = "ssl-repo-client-keystore-passwords.properties",
  $alfresco_truststore_filename = "ssl.repo.client.truststore",
  $alfresco_truststore_pwd_file = "ssl-repo-client-truststore-passwords.properties",
  $user,
  $group,
){
  file {"${install_dir}/${core_name}-SpacesStore/conf/solrcore.properties":
      ensure  => present,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      content => template('solr/solrcore.erb')
  }
  
}