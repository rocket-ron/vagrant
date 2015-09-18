node 'rmq01.rmqnode.localdomain' {
  include ::role::rmqnode::server::vagrant
}
node 'rmq02.rmqnode.localdomain' {
  include ::role::rmqnode::server::vagrant
}

class role {
  include ::profile::base 
  package { "erlang": 
    ensure => installed,
    require => Yumrepo["erlang-solutions"]
  }
}

class role::rmqnode::server inherits role {
  include ::profile::rmqnode::rabbitmq
}

class role::rmqnode::server::vagrant inherits role::rmqnode::server {
#  include ::profile::rmqnode::networking::vagrant
  include ::profile::rmqnode::rabbitmq::vagrant
}

# Profile definitions
class profile::base {
  include stdlib
  anchor{'begin':}
  anchor{'end':}
  class {'::epel':}
  yumrepo { "erlang-solutions":
    baseurl    => 'http://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch',
    descr      => 'The erlang_solutions repository',
    enabled    => '1',
    gpgcheck   => '1',
    gpgkey     => 'http://packages.erlang-solutions.com/rpm/erlang_solutions.asc'
  }
  package {[
    'git']:
      ensure => installed, 
  }
  user { "rcordell":
    name  => 'rcordell',
    ensure  => 'present',
    shell => '/bin/bash',
    password  => '685addb7fc7d06ec07b91a611ff351e5',
    managehome => true,
  }
}

class profile::rmqnode::rabbitmq inherits profile::base {
}

class profile::rmqnode::rabbitmq::vagrant inherits profile::rmqnode::rabbitmq {
  class {'::rabbitmq':
    port      => '5672',
    default_user  => 'admin',
    default_pass  => 'admin',
    package_source => 'http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.4/rabbitmq-server-3.5.4-1.noarch.rpm',
    package_provider => rpm,
    package_ensure => installed,
    service_ensure => running,
    require => Package['erlang']
  }
}

