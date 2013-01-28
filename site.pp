# Create stage to run before main configuration
stage { 'first':
  before => Stage['main'],
}

# Add node template classes and node definitions from Hiera
import 'templates'
hiera_include(roles)
