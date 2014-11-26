class cman {

  anchor {
    'cman::begin':
      require => [ Package['cman', 'ccs'], File['/etc/sysconfig/cman'] ],
  }

  package {
    'cman':
      ensure => installed;
    'ccs':
      ensure => installed;
  }

  file {
    '/etc/sysconfig/cman':
        ensure  => 'file',
        source  => 'puppet:///modules/cman/sysconfig-cman',
        owner   => root,
        group   => root,
        mode    => '0644',
        require => [ Package['cman'], Package['ccs'] ],
  }
}
