Exec { path => [ "/bin/", "/sbin", "/usr/bin", "/usr/sbin" ] }

class system-update {
  exec { 'yum update':
    command => 'yum update -y',
  }
}


class install-git {
  exec { 'install git':
    command => 'yum install -y git',
  }
}

class epel-release {
  exec { 'epel release':
    command => "yum install -y epel-release",
    require => Class["system-update"],
  }
}

class python-pip {
  exec { 'install pip':
    command => 'yum install -y python-pip',
    require => Class["epel-release"],
  }
}


class python-modules {
  exec { 'tweepy':
    command => 'pip install tweepy',
    require => Class["python-pip"],
    }
  exec { 'pymongo':
    command => 'pip install pymongo',
    require => Class["python-pip"],
  }
  exec { 'termcolor':
    command => 'pip install termcolor',
    require => Class["python-pip"],
  }
}

class {'::mongodb::globals':
  manage_package_repo => true,
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

yumgroup {'Development tools': ensure => present, require => Class['system-update'], }

include system-update
include install-git
include epel-release
include python-pip
include python-modules
include stdlib
include user-creation
