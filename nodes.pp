# The basic set of classes that will apply to most nodes
node basenode {
  include base

  Network::If::Static {
    netmask => '255.255.255.0',
    gateway => '192.168.56.1',
    dns1    => '128.146.1.7',
    dns2    => '128.146.48.7',
    domain  => 'eng-web.local',
    ensure  => 'up',
  }
}

# The configuration applied by default
node default inherits basenode {}

node 'control.eng-web.local' inherits basenode {
  include puppetmaster

  network::if::static { 'eth0':
    ipaddress  => '192.168.56.51',
    macaddress => $macaddress_eth0,
  }
}