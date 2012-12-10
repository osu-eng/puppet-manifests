# Defines the classes that should included in various roles.

# Base class used by all nodes
class base {
  include general
  include mail
  include firewall_rules
  class { 'ntp':
    servers => [
      'ntp1.service.ohio-state.edu',
      'ntp2.service.ohio-state.edu',
      '0.us.pool.ntp.org',
      '1.us.pool.ntp.org'
    ],
  }
  class { 'puppet': 
    puppetserver => 'control.eng-web.local',
  }
  class { 'motd': 
    message => 'Welcome to the College of Engineering web infrastructure!',
  }
  class { 'ssh': }
}

# Node role definitions
class puppetmaster {
  include puppet::master
}

