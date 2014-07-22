class ci_profiles::zuul(
  $vhost_name    = $::ipaddress,
  $gerrit_server = 'review.openstack.org',
  $gerrit_user,
  $zuul_ssh_private_key,
) {

  include '::zuul::server'
  include '::zuul::merger'

  Service <| title == 'zuul' |> {
    ensure  => running,
    require +> Class['zuul'],
  }

  Service <| title == 'zuul-merger' |> {
    ensure  => running,
    require => Service['zuul'],
  }

  class { '::zuul':
    vhost_name           => $vhost_name,
    gearman_server       => '127.0.0.1',
    gerrit_server        => 'review.openstack.org',
    # I need to create another user for this so that I don't have to use my own...
    gerrit_user          => $gerrit_user,
    # private key for gerrit user
    zuul_ssh_private_key => $zuul_ssh_private_key,
    url_pattern          => '',
    zuul_url             => '',
    job_name_in_report   => true,
    status_url           => "http://${vhost_name}/",
    #statsd_host          => $statsd_host,
    #git_email            => 'jenkins@openstack.org',
    #git_name             => 'OpenStack Jenkins',
  }


  file { '/etc/zuul/layout.yaml':
    ensure => present,
    source => 'puppet:///modules/ci_profiles/zuul/layout.yaml',
    notify => Exec['zuul-reload'],
  }

  file { '/etc/zuul/openstack_functions.py':
    ensure => present,
    source => 'puppet:///modules/ci_profiles/zuul/openstack_functions.py',
    notify => Exec['zuul-reload'],
  }

  file { '/etc/zuul/logging.conf':
    ensure => present,
    source => 'puppet:///modules/ci_profiles/zuul/logging.conf',
    notify => Exec['zuul-reload'],
  }

  file { '/etc/zuul/gearman-logging.conf':
    ensure => present,
    source => 'puppet:///modules/ci_profiles/zuul/gearman-logging.conf',
    notify => Exec['zuul-reload'],
  }

  file { '/etc/zuul/merger-logging.conf':
    ensure => present,
    source => 'puppet:///modules/ci_profiles/zuul/merger-logging.conf',
  }

  file { '/home/zuul/.ssh':
    ensure  => directory,
    owner   => 'zuul',
    group   => 'zuul',
  }

  # why do I have to add this and they don't perhaps b/c something was wrong with
  # the ssh agent on the image that I created?
  file { '/home/zuul/.ssh/config':
    owner   => 'zuul',
    group   => 'zuul',
    content => "Host review.openstack.org\n  IdentityFile /var/lib/zuul/ssh/id_rsa\n  StrictHostKeyChecking no"
  }

}
