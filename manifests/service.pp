# manage syslog-ng service
class syslog_ng::service {
  service { 'syslog_ng':
    ensure     => 'running',
    name       => 'syslog-ng',
    hasstatus  => true,
    hasrestart => true,
  }
}
