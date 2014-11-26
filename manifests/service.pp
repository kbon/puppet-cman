class cman::service(
  $ensure='running',
  $enable=true
) {

  service {
    'cman':
      ensure     => $ensure,
      enable     => $enable,
      hasstatus  => true,
      hasrestart => true,
      require    => Class['cman'],
  }

}
