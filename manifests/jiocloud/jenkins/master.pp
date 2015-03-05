class rjil::jiocloud::jenkins::master {
  include ::jenkins
  include ::rjil::jiocloud::jenkins

  jenkins::plugin {
    'ant':                       version => '1.2';
    'credentials':               version => '1.18';
    'cvs':                       version => '2.12';
    'delivery-pipeline-plugin':  version => '0.8.6';
    'external-monitor-job':      version => '1.2';
    'git-client':                version => '1.11.0';
    'git':                       version => '2.2.7';
    'greenballs':                version => '1.14';
    'javadoc':                   version => '1.2';
    'jquery':                    version => '1.7.2-1';
    'jquery-ui':                 version => '1.0.2';
    'junit':                     version => '1.1';
    'ldap':                      version => '1.11';
    'mailer':                    version => '1.11';
    'mapdb-api':                 version => '1.0.1.0';
    'matrix-auth':               version => '1.2';
    'matrix-project':            version => '1.4';
    'maven-plugin':              version => '2.7';
    'antisamy-markup-formatter': version => '1.2';
    'pam-auth':                  version => '1.2';
    'parameterized-trigger':     version => '2.25';
    'scm-api':                   version => '0.2';
    'ssh-credentials':           version => '1.10';
    'ssh-slaves':                version => '1.8';
    'subversion':                version => '2.4.4';
    'token-macro':               version => '1.10';
    'translation':               version => '1.11';
  }

  file { '/home/jenkins/.gitconfig':
    owner  => 'jenkins',
    group  => 'jenkins',
    source => 'puppet:///modules/rjil/jenkins-gitconfig',
    mode   => '0644',
    ensure => present
  }
}
