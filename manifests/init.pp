### This is the base module that gets applied to EVERY machine managed by puppet. Anything else should be

### included in a node manifest or created as/added to a module.

class base{
  case $operatingsystem {
     centos, redhat: {
  
  
### Create the default /cul file structure

$culroot    =   '/cul'
$approot    =   '/cul/app'
$webroot    =   '/cul/web'
$dbroot     =   '/cul/db'
$logroot    =   '/cul/log'
$culbin     =   '/cul/bin'
$culshare   =   '/cul/share'
$culbackup  =   '/cul/backup'
$culdata    =   '/cul/data'
$culsrc     =   '/cul/src'


                file {"${culroot}":
            ensure  => directory,
            owner   => root,
            group   => root,
                    replace => false,
            mode    => 755
        }

                file {"${approot}":
                        ensure  => directory,
                        owner   => root,
                        group   => root,
                        mode    => 755,
            require => File["${culroot}"]
                }

                file {"${webroot}":
                        ensure  => directory,
                        owner   => root,
                        group   => root,
                        mode    => 755,
                        require => File["${culroot}"]
                }

                file {"${dbroot}":
                        ensure  => directory,
                        owner   => root,
                        group   => root,
                        mode    => 755,
                        require => File["${culroot}"]
                }

                file {"${logroot}":
                        ensure  => directory,
                        owner   => root,
                        group   => root,
                        mode    => 755,
                        require => File["${culroot}"]
                }

        file {"${culbin}":                                                                                            
                        ensure  => directory,                                                                                
                        owner   => root,                                                                                     
                        group   => root,                                                                                     
                        mode    => 755,                                                                                      
                        require => File["${culroot}"]                                                                          
                }
                
        file {"${culshare}":
                        ensure  => directory,
                        owner   => root,
                        group   => root,
                        mode    => 755,
                        require => File["${culroot}"]
                }
           
        file {"${culbackup}":                                                                                                                            
                        ensure  => directory,                                                                                                                   
                        owner   => root,                                                                                                                        
                        group   => root,                                                                                                                        
                        mode    => 755,                                                                                                                         
                        require => File["${culroot}"]                                                                                                           
                }

        file {"${culdata}":                                                                                                                            
                        ensure  => directory,                                                                                                                   
                        owner   => root,                                                                                                                        
                        group   => root,                                                                                                                        
                        mode    => 755,                                                                                                                         
                        require => File["${culroot}"]                                                                                                           
                }
       
 
        file {"${culsrc}":
                ensure  => directory,                                                                                                                   
                        owner   => root,                                                                                                                        
                        group   => root,                                                                                                                        
                        mode    => 755,                                                                                                                         
                        require => File["${culroot}"]
                }

                
                file {'/etc/yum.repos.d/libsys.repo':
            source  => 'puppet:///modules/base/libsys.repo',
            owner   => 'root',
            group   => 'root',
            mode    => '644'
              }

        file { "${culshare}/nicenames":
            ensure  => present,
            source  => 'puppet:///modules/base/nicenames',
            owner   => root,
            group   => root,
            mode    => 755,
              }
    
        file { "${culbin}/nicename":
            ensure => file,
            source => 'puppet:///modules/base/nicename.sh',
            mode   => 0755,
            require => File["${culshare}/nicenames"],
        }
            
        file { "/bin/perl":
            ensure  => link,
            target  => "/usr/bin/perl"
        }

        file { "/etc/profile.d/cul.sh":
            ensure  => present,
            source  => 'puppet:///modules/base/cul.sh',
        }
        
        package { "ruby-rdoc":
            ensure  => installed,
        }

        package {"apg":
            ensure  => installed,
        }

        package {'perl-Config-General':
            ensure  => installed,
        }

        package {'perl-Config-Simple':
            ensure  => installed,
        }

        file {'/var/lib/puppet/state':
            ensure  => directory,
            mode    => '1755',
            }

        service { "puppet":
                enable      => "true",
                ensure      => "running",
                hasstatus   => "true"
            }
#Pull in user home directory contents

cul_users { $users_array:; }

   #Set up our local nagios plugins
    if $fqdn !~ /^vclnode(\d+)\./ {
        include cul_nagios
    }
   }
  }
}
