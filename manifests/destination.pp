# Generic syslog destination
define syslog_ng::destination (
  $spec   = undef,
  $target = $::syslog_ng::config_file_destination_files,
  ) {
  validate_string($target)
  $entry_type = 'destination'
  concat::fragment{ "destination_${name}":
    target  => $target,
    content => template('syslog_ng/entry.erb')
  }
}

# syslog file destination
define syslog_ng::destination::file (
    $file      = undef,
    $owner     = undef,
    $group     = undef,
    $dir_owner = undef,
    $dir_group = undef,
    $perm      = undef,
    $target    = $::syslog_ng::config_file_destination_files,
  ){
  syslog_ng::destination {$name:
    spec   => inline_template("file('${file}' <%= scope.function_template(['syslog_ng/fileparams.erb']) %>);"),
    target => $target
  }
  file {$file:
    ensure => file,
    owner  => $owner,
    group  => $group,
    mode   => $perm
  }
}

# syslog network destination
define syslog_ng::destination::network (
  $log_server = undef,
  $log_port   = undef,
  $proto      = 'udp',
  ) {
  case $proto {
    'UDP', 'udp': {
      syslog_ng::destination {$name:
        spec   => "udp('${log_server}' port(${log_port}) log_fifo_size(${::syslog_ng::log_fifo_size_destination}));",
        target => $syslog_ng::params::config_file_destination_remote
      }
    }
    'TCP', 'tcp': {
      syslog_ng::destination {$name:
        spec   => "tcp('${log_server}' port(${log_port}) log_fifo_size(${::syslog_ng::log_fifo_size_destination}));",
        target => $syslog_ng::params::config_file_destination_remote
      }
    }
    'TLS', 'tls': {
      syslog_ng::destination {$name:
        spec   => "tcp('${log_server}' port(${log_port}) tls(ca_dir(\"${::syslog_ng::ca_dir}\")) log_fifo_size(${::syslog_ng::log_fifo_size_destination}));",
        target => $syslog_ng::params::config_file_destination_remote
      }
    }
    default: {
      fail("${proto} is not supported by syslog_ng::client")
    }
  }
}
