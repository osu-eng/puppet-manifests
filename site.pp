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
import 'templates'
hiera_include(roles)
