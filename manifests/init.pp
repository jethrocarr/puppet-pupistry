# Shell for including task-specific files & parameters
class pupistry (
  $puppet_pluginsync  = $pupistry::params::puppet_pluginsync,
  $install_pupistry   = $pupistry::params::install_pupistry,
  $install_daemon     = $pupistry::params::install_daemon,
  $init_system        = $pupistry::params::init_system,
  ) inherits pupistry::params {

  include pupistry::install
  include pupistry::puppet

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
