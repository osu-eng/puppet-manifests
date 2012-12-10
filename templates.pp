# Defines the classes that should included in various roles.

# Base class used by all nodes
class base {
  include general
  include mail
  include firewall_rules

  Network::If::Static {
    netmask      => '255.255.255.0',
    gateway      => '164.107.58.1',
    dns1         => '128.146.1.7',
    dns2         => '128.146.48.7',
    domain       => 'eng-web.local',
    ensure       => 'up',
  }
  class { 'resolv':
    dns => [
      '128.146.1.7',
      '128.146.48.7'
    ],
    domain => 'eng-web.local',
    search => 'eng-web.local',
  }

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

