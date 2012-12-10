# Defines the classes that should included in various roles.

class base {
  include general
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

class puppetmaster {
  include puppet::master
}
