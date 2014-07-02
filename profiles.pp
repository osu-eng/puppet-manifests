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
    log_remote     => true,
    remote_type    => 'tcp',
    log_local      => false,
    log_auth_local => false,
    custom_config  => undef,
    port           => '514',
    server         => 'logs.web.engineering.osu.edu',
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

  # Allow our mysql clients to talk to our  server
  firewall::rule { 'allow-rsyslog-server':
    weight => '375',
    rule   => '-A INPUT -p tcp -m state --state NEW,ESTABLISHED -m tcp --dport 3306 -j ACCEPT',
  }  
}

class webserver {
  include apache
  include php::apache
  # include mysql::repos
  # include mysql::client
}

class logserver {

  include apache
  include vcsrepo

  vcsrepo { "/etc/logstash/conf.d":
    ensure => present,
    provider => git,
    source => "git@github.com:osu-eng/logstash-config.git"
  }

  class { 'elasticsearch':
    manage_repo  => true,
    repo_version => '1.2',
    version => '1.2.1-1',
    java_install => true
  }

  elasticsearch::instance { 'es-01': }

  class { 'logstash':
    package_url => 'https://download.elasticsearch.org/logstash/logstash/packages/centos/logstash-1.4.2-1_2c0f5a1.noarch.rpm',
    install_contrib => true,
    contrib_package_url => 'https://download.elasticsearch.org/logstash/logstash/packages/centos/logstash-contrib-1.4.2-1_efd53ef.noarch.rpm'
  }


  #user { 'logstash-user':
  #  ensure   => present,
  #  name     => 'logstash',
  #  gid      => 'logstash',
  #  shell    => '/sbin/nologin',
  #  home     => '/var/logstash',
  #  require  => [ Group['logstash-group'] ],
  #}

  #group { 'logstash-group':
  #  name  => 'logstash',
  #}

  # class { 'logstash::java': }
  # class { 'logstash':    
  #   provider => 'custom',
  #   jarfile  => 'puppet:///modules/logstash/bin/logstash-current.jar',
  #   installpath => '/var/logstash',
  #   logstash_user  => 'root',
  #   logstash_group => 'root'
  # }
  

  # logstash::input::file { 'logstash-syslog':
  #   path    => [ '/var/log/aggregated/*/syslog' ],
  #   type    => 'syslog',
  #   sincedb_path => '/var/logstash/sincedb.syslog',
  # }
  # logstash::input::file { 'logstash-auth':
  #   path    => [ '/var/log/aggregated/*/auth.log' ],
  #   type    => 'syslog',
  #   sincedb_path => '/var/logstash/sincedb.auth',
  # }

  # logstash::output::elasticsearch { 'logstash-elasticsearch':
  #   embedded                  => true,
  # }    
  
  # # Use rsyslog server
  # class { 'rsyslog::server':
  #   enable_tcp                => true,
  #   enable_udp                => true,
  #   enable_onefile            => false,
  #   server_dir                => '/var/log/aggregated/',
  #   custom_config             => undef,
  #   high_precision_timestamps => false,
  # }  

  # # Allow our rsyslog clients to talk to our rsyslog server
  # firewall::rule { 'allow-rsyslog-server':
  #   weight => '375',
  #   rule   => '-A INPUT -p tcp -m state --state NEW,ESTABLISHED -m tcp --dport 514 -j ACCEPT',
  # }    

  # elastic search seems to require log4j
  # package { 'log4j':
  #  ensure => present,
  # }

  # Install elastic search, docs say version must match logstash
  # class { 'elasticsearch':
  #  pkg_source => 'puppet:///modules/elasticsearch/elasticsearch-0.90.3.noarch.rpm'
  #  config      => {
  #    'network' => {
  #      'host'  => '127.0.0.1',
  #    }
  #  }
  #} 
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
