# The following parameters provide configuration for Pupistry. Generally the
# defaults should be good for most users, however if you wish to change any
# of the values, you can do so by simply changing the parms when invoking
# Pupistry or in Hiera. See the README for details.

class pupistry::params {

  # Emulate the pluginsync option in Puppet master/slave. Generally you will
  # want this set to true.
  $puppet_pluginsync  = true

  # Install latest version of Pupistry from Rubygems
  $install_pupistry   = true

  # Install the background Pupistry daemon to provide regular checks for new
  # artifacts and doing Puppet runs.
  $install_daemon     = true

  # We use the jethrocarr/initfact module to identify the init system for us
  $init_system = $::initsystem

  if (!$init_system) {
    fail('Install the jethrocarr/initfact module to provide identification of the init system being used. Required to make this module work.')
  }

}



# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
