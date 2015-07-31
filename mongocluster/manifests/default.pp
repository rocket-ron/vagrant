Exec { path => [ "/bin/", "/sbin", "/usr/bin", "/usr/sbin" ] }

class system-update {
  exec { 'yum update':
    command => 'yum update -y',
  }
}

class dev-tools {
  exec { 'dev tools':
    command => 'yum groupinstall \"Development Tools\" -y',
    require => Class["system-update"],
  }
}

class install-git {
  exec { 'install git':
    command => 'yum install -y git',
    require => Class['dev-tools'],
  }
}

class epel-release {
  exec { 'epel release':
    command => "yum install -y epel-release",
  }
}

class python-pip {
  exec { 'install pip':
    command => 'yum install -y python-pip',
    require => Class["dev-tools", "epel-release"],
  }
}

class upgrade-pip {
  exec{ 'upgrade pip':
    command => "pip install 'pip>1.5' --upgrade",
    require => Class["python-pip"],
    }
}

class python-modules {
  exec { 'tweepy':
    command => 'pip install tweepy',
    require => Class["upgrade-pip"],
    }
  exec { 'pymongo':
    command => 'pip install pymongo',
    require => Class["upgrade-pip"],
  }
}

class {'::mongodb::globals':
  manage_package_repo => true,
}->
class {'::mongodb::server':
  verbose => true,
  bind_ip => ['0.0.0.0'],
  require => Class["system-update"],
}->
class {'::mongodb::client':}

class user-creation {
  user { "rcordell":
    name 	=> 'rcordell',
    ensure 	=> 'present',
    shell	=> '/bin/bash',
    password	=> '685addb7fc7d06ec07b91a611ff351e5',
    managehome => true,
  }
}

class my_fw::pre {
  Firewall {
    require => undef,
  }

  firewall { '100 accept traffic on mongoDB port 27017':
    port    => 27017,
    proto   => 'tcp',
    action  => 'accept',
  }
}

resources { 'firewall':
  purge => false,
}

Firewall {
  require => Class['my_fw::pre'],
}


include my_fw::pre

include install-git
include epel-release
include dev-tools
include python-pip
include system-update
include python-modules
include upgrade-pip
include stdlib
include user-creation
