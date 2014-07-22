class ci_profiles::jenkins(
  $jenkins_url        = 'http://127.0.0.1:8080',
  $service_sleep_time = 120,
  $user,
  $password,
) {

  include ::jenkins, ::jenkins::master

  include ci_profiles::jenkins::jobs
  include ci_profiles::jenkins::plugins
  include openstack_tester::puppet_jobs

  Service['jenkins'] ~> Exec['sleep_two_min'] -> Exec['jenkins_jobs_update']

  exec { 'sleep_two_min':
    command     => "/bin/sleep ${service_sleep_time}",
    refreshonly => true,
  }

  package { 'git':
    ensure => installed,
  }

  file { '/etc/jenkins_jobs/config':
    ensure => directory,
    before => Exec['jenkins_jobs_update'],
  }

  class { 'jenkins_job_builder':
    url      => $jenkins_url,
    username => $user,
    password => $password,
    require  => Package['git']
  }


}
