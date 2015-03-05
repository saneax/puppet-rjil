class rjil::jenkins (
  $python_jenkins_pip_url,
  $jenkins_job_builder_url,
) {

  notice ("Imported from hiera - $rjil::jenkins::python_jenkins_pip_url ")

  include ::rjil::base
  include ::rjil::jiocloud::jenkins
  include ::jenkins


  package { [ 'bzr',  'libyaml-dev' ]:
    ensure => installed,
  }

  ::python::virtualenv { 'venv':
    ensure   => present,
    venv_dir => '/tmp/venv',
    timeout  => 0,
    owner    => jenkins,
    group    => jenkins,
  }

  if defined ($python_jenkins_pip_url) {
    ::python::pip { 'python-jenkins':
      ensure     => present,
      virtualenv => '/tmp/venv',
      url        => $python_jenkins_pip_url,
    }
  }

  if defined ($jenkins_job_builder_url) {
    ::python::pip { 'jenkins-job-builder':
      ensure     => present,
      virtualenv => '/tmp/venv',
      url        => $jenkins_job_builder_url,
    }
  }

  file { '/home/jenkins/.gitconfig':
    owner  => 'jenkins',
    group  => 'jenkins',
    source => 'puppet:///modules/rjil/jenkins-gitconfig',
    mode   => '0644',
    ensure => present
  }


}
