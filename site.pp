# Create stage to run before main configuration
stage { 'first':
  before => Stage['main'],
}

# Define the default file bucket
$puppetmaster = hiera('puppet::server')
filebucket { 'main':
  server => $puppetmaster,
  path   => false,
}
File { backup => main }

# Add node template classes and node definitions from Hiera
import 'roles'
import 'profiles'

# Store node role in a global variable
$role = hiera('role')
include $role
