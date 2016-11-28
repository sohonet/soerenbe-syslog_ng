class syslog_ng::config {

  include syslog_ng::params

  file { '/etc/syslog-ng/':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { '/etc/syslog-ng/scl.conf':
    source => 'puppet:///modules/syslog_ng/scl.conf',
  }

  file { $::syslog_ng::config_dir:
    ensure  => directory,
    recurse => true,
    purge   => true,
  }

  # Basic configuration
  file { '/etc/syslog-ng/syslog-ng.conf':
    content => template('syslog_ng/syslog-ng.conf.erb'),
    notify  => Service[syslog_ng],
  }
  # Basic logging
  syslog_ng::source::system {$::syslog_ng::local_source: }
  syslog_ng::default {'default':
    source    => $::syslog_ng::local_source,
    directory => $::syslog_ng::system_log_dir,
    owner     => 'root',
    group     => 'syslog',
    perm      => '0775',
  }

}
