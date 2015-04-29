# Logic that changes the way Puppet behaves.

class pupistry::puppet {

  # There is no support for pluginsync when running masterless, meaning that you
  # puppet facts won't work. The following does the same thing as plugin sync
  # when running masterless.
  # TODO: Do we need logic to determine if masterless or not?

  if ($puppet_pluginsync == true) {
    file { $::settings::libdir:
      ensure  => directory,
      source  => 'puppet:///plugins',
      recurse => true,
      purge   => true,
      backup  => false,
      noop    => false
    }
  }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
