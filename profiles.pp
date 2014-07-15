# Defines profiles that can add functionality to roles.

# Base class used by many nodes
class base {
  # Make sure puppet configuration is pushed out first
  class { 'puppet':
    stage => first
  }

  include epel
  include general
  include auth
  include mail
  include firewall::base
  include ntp
  include motd
  include network_settings
  include network_settings::hosts
  include ssh
  include ssh::known_hosts
  include services
  include cron
  include selinux
  include logrotate::base
  include sudo
  include vmwaretools

  # Red Hat Enterprise Linux activation
  if $::operatingsystem == 'RedHat' {
    class { 'rhn':
      stage => first,
    }
  }

  # Enable rsyslog
  class { 'rsyslog::client':
    log_remote     => false,
    log_local      => true
  }
}

# Node role definitions
class puppetmaster {
  include puppet::master
}

class ldap {
  include auth::ldap_server
}

class shibboleth {
  include shibboleth_server
}

class aegirmaster {
  include aegir::master
}

class aegirslave {
  include aegir
}

class database {
  include mysql::repos
  include mysql::server
  include mysql::server::account_security
  include mysql::server::mysqltuner
  include mysql::server::backup
  include log_client

  # Allow our mysql clients to talk to our  server
  firewall::rule { 'allow-rsyslog-server':
    weight => '375',
    rule   => '-A INPUT -p tcp -m state --state NEW,ESTABLISHED -m tcp --dport 3306 -j ACCEPT',
  }  
}

class webserver {
  include apache
  include php::apache
  include log_client::web
  # include mysql::repos
  # include mysql::client
}

class logserver {
  include elk
}


class analyticsserver {

}

class opcode_cache {
  include php::apc
}

class newrelicclient {

}

class cluster_node {
  include cluster::node
  include cluster::file_system
}

class cluster_manager {
  include cluster::manager
}

class virtual_server {
  include piranha
}

class real_server {
  include piranha::real_server
}

class unitrends_client {
  include unitrends
  include inetd
}

class unitrends_database {
  # include unitrends::mysql
}

class rails_app {
  include rvm
  include rubies
  include capistrano

  package { 'mysql-devel':
    ensure => present,
  }

  class { 'rvm::passenger::apache':
    require => [ Class['rubies'], Class['apache'] ]
  }

}
