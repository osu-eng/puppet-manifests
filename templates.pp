# Defines the classes that should included in various roles.

# The basic set of classes that will apply to most nodes
node basenode {
  include base
}

# The configuration applied by default
node default inherits basenode {}