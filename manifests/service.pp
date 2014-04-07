class cman::service($ensure='running',
                    $enable=true) {
  include cman
  service { 'cman':
                      ensure     => $ensure,
                      enable     => $enable,
                      hasstatus  => true,
                      hasrestart => true,
                      require    => [ Anchor['cman::begin'] ],
  }

}
