define solr::solrcore(
  $core_name,
  $install_dir,
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