# The following parameters provide configuration for Pupistry. Generally the
# defaults should be good for most users, however if you wish to change any
# of the values, you can do so by simply defining override values in Hiera.

class pupistry::params {

  # Emulate the pluginsync option in Puppet master/slave. Generally you will
  # want this set to true.
  $puppet_pluginsync  = true

  # Install latest version of Pupistry from Rubygems
  $install_pupistry   = true

  # Install the background Pupistry daemon to provide regular checks for new
  # artifacts and doing Puppet runs.
  $install_daemon     = true


  # Determine what init system is running on this system
  $init_system = $::osfamily ? {

    'RedHat' => $::operatingsystemmajrelease ? {
      '5'     => 'sysvinit',
      '6'     => 'sysvinit',
      '7'     => 'systemd',
      default => 'systemd',
    },
    
    'FreeBSD' => $::operatingsystemmajrelease ? {
      '10'    => 'bsdinit',
      default => 'bsdinit',
    },

    'Debian' => $::operatingsystem ? {
      'Ubuntu' => $::operatingsystemmajrelease ? {
        '12.04' => 'sysvinit',  # We don't provide upstart scripts, use sysvinit mode
        '14.04' => 'sysvinit',  # We don't provide upstart scripts, use sysvinit mode
        default => 'systemd',   # All future Ubuntu versions will be systemd
      },

      # See comments below re defaults.
      default => 'sysvinit',
    },

    # Default for any unknown system is sysvinit since most distros inc systemd
    # using still support sysvinit scripts. In future, this default will change
    # to systemd, so if you're using sysvinit and you're not listed in the above
    # logic, please send in a pull request to avoid it suddenly changing.
    default   => 'sysvinit',
  }


}



# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
