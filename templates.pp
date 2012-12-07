# Defines the classes that should included in various roles.

# The basic set of classes that will apply to most nodes
node basenode {
  include base
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
}

# The configuration applied by default
node default inherits basenode {}
