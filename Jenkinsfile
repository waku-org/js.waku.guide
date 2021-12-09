pipeline {
  agent { label 'linux' }

  options {
    disableConcurrentBuilds()
    /* manage how many builds we keep */
    buildDiscarder(logRotator(
      numToKeepStr: '20',
      daysToKeepStr: '30',
    ))
  }

  environment {
    GIT_COMMITTER_NAME = 'status-im-auto'
    GIT_COMMITTER_EMAIL = 'auto@status.im'
    /* dev page settings */
    DEV_SITE = 'dev-docs.dappconnect.dev'
    DEV_HOST = 'jenkins@node-01.do-ams3.sites.misc.statusim.net'
    SCP_OPTS = 'StrictHostKeyChecking=no'
  }

  stages {
    stage('Build') {
      steps {
        sh "hugo ${env.GIT_BRANCH ==~ /.*master/ ? '' : "-b https://${DEV_SITE}"}"
      }
    }

    stage('Publish Prod') {
      when { expression { env.GIT_BRANCH ==~ /.*master/ } }
      steps {
        sshagent(credentials: ['status-im-auto-ssh']) {
          sh "ghp-import -p public"
        }
      }
    }

    stage('Publish Devel') {
      when { expression { env.GIT_BRANCH ==~ /.*develop/ } }
      steps {
        sshagent(credentials: ['jenkins-ssh']) {
          sh """
            rsync -e 'ssh -o ${SCP_OPTS}' -r --delete public/. \
              ${env.DEV_HOST}:/var/www/${env.DEV_SITE}/
          """
        }
      }
    }
  }
}
