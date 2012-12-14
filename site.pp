import 'templates'
hiera_include(roles)

# Firewall configuration
exec { 'persist-firewall':
  command     => $operatingsystem ? {
    'debian'          => '/sbin/iptables-save > /etc/iptables/rules.v4',
    /(RedHat|CentOS)/ => '/sbin/iptables-save > /etc/sysconfig/iptables',
  },
  refreshonly => true,
}

Firewall {
  notify  => Exec['persist-firewall'],
  before  => Class['firewall_rules::post'],
  require => Class['firewall_rules'],
}
Firewallchain {
  notify  => Exec['persist-firewall'],
}
