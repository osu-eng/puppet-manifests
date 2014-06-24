# Defines the roles that can be performed by nodes.

class infrastructure_controller {
  include base
  include puppetmaster
  include ldap
  include webserver
  include cluster_manager
}

class database_cluster_node {
  include base
  include database
  include cluster_node
  include unitrends_client
  include unitrends_database
}

class web_cluster_node {
  include base
  include webserver
  include opcode_cache
  include shibboleth
  include cluster_node
  include aegirslave
  include real_server
  include unitrends_client
}

class web_cluster_platform_manager {
  include base
  include webserver
  include cluster_node
  include aegirmaster
  include shibboleth
  include unitrends_client
}

class load_balancer {
  include base
  include virtual_server
}

class log_server {
  include base
}

class analytics_server {
  include base
  include analyticsserver
}

class web_platform_manager {
  include base
  include shibboleth
  include aegirmaster
  include newrelicclient
  include webserver
}

class database_server {
  include base
  include database
}

class application_server {
  include base
  include webserver
  include rails_app
}

class security_scanner {
  include base
  include unitrends_client
}
