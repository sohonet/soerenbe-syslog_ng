# Install syslog-ng with basic logging
class syslog_ng::install {

  package { 'rsyslog':
    ensure  => absent,
  }->

  package { $::syslog_ng::package_name:
    ensure  => present,
  }

}
