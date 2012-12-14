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
  include network_settings::hosts
  include ssh
  include services
  include cron
  include selinux
}

# Node role definitions
class puppetmaster {
  include puppet::master
}
