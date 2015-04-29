# Installation of Pupistry
#
class pupistry::install {

  # Ensure latest version of Pupistry is installed. This will upgrade Pupistry
  # if appropiate via Rubygems. If you have a system OS package for Pupistry,
  # you may want to have this turned off to avoid issues.

  if ($pupistry::install_pupistry) {
    if ($pupistry::install_daemon) {
      # Daemon is installed, we want to reload the Pupistry service.
      package { 'pupistry':
        ensure   => latest,
        provider => gem,
        notify   => Service['pupistry']
      }
    }
    else
    {
      # No daemon installed so nothing to reload but we do want latest version
      # of Pupistry still.
      package { 'pupistry':
        ensure   => latest,
        provider => gem,
      }
    }
  }


  # Setup the daemon. This in simple in theory, but more complex than it should
  # be in reality due to the need to install a different type of init file,
  # depending whether the daemon is running on Linux with sysvinit, Linux with
  # systemd, or another UNIX like FreeBSD.
  #
  # OS/init discovery is done in params.pp, here we just install the appropiate
  # files for each platform.

  if ($pupistry::install_daemon) {
    notify { "Would have installed daemon, for init type ${pupistry::init_system}": }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
