# Defines the classes that should included in various roles.

# Base class used by all nodes
class base {
  # Make sure puppet configuration is pushed out first
  class { 'puppet':
    stage => first
  }

  include general
  include auth
  include mail
  include firewall_rules
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

class database {
  include mysql::server
}

class webserver {
  include apache
  include php::apache
  include php::apc
}
