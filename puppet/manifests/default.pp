# Make sure apt-get -y update runs before anything else.
stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { '/usr/bin/apt-get -y update':
    user => 'root'
  }
}

class { 'apt_get_update':
  stage => preinstall
}

package { [ 'build-essential',
'git-core',
'libfontconfig']:
  ensure => installed,
}



class { 'nodejs':
  manage_repo => true
}

package { 'npm':
  ensure   => '2.1.4',
  provider => 'npm',
  require => Package['nodejs'],
}

package { 'yo':
  ensure   => present,
  provider => 'npm',
  require => Package['nodejs'],
}

package { 'grunt-cli':
  ensure   => present,
  provider => 'npm',
  require => Package['nodejs'],
}

package { 'bower':
  ensure   => present,
  provider => 'npm',
  require => Package['nodejs'],
}

package { 'phantomjs':
  ensure   => present,
  provider => 'npm',
  require => Package['nodejs'],
}



class install_postgres {
  class { 'postgresql': }

  class { 'postgresql::server': }

  pg_user { 'vagrant':
    ensure    => present,
    superuser => true,
    require   => Class['postgresql::server']
  }

  package { 'libpq-dev':
    ensure => installed
  }
}
class { 'install_postgres': }



class install-rvm {
  include rvm
  rvm::system_user { vagrant: ; }

  rvm_system_ruby {
    'ruby-2.1.3':
      ensure => 'present',
      default_use => true,
      build_opts => ['--binary'];
  }

  rvm_gem {
    'ruby-2.1.3/bundler': ensure => latest, require => Rvm_system_ruby['ruby-2.1.3'];
    'ruby-2.1.3/rails-api': ensure => latest, require => Rvm_system_ruby['ruby-2.1.3'];
    'ruby-2.1.3/rake': ensure => latest, require => Rvm_system_ruby['ruby-2.1.3'];
  }

}

class { 'install-rvm': }
