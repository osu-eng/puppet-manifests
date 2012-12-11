# Defines the classes that should included in various roles.

# Base class used by all nodes
class base {
  include general
  include mail
  include firewall_rules
  include puppet
  include ntp
  include motd
  include network_settings
  include ssh
  include services
}

# Node role definitions
class puppetmaster {
  include puppet::master
}
