
pipeline {

   
     environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

   agent any 

   tools {
      terraform "terraform"
   } 

    stages {
      stage('fetch_latest_code') {
        steps {
          git branch: 'jenkins', url: 'https://github.com/erwindaniel/terraform-jenkins1.git'
        }
      }

      stage('TF Init&Plan') {
        steps {
          sh 'terraform init'
          sh 'terraform plan'
        }      
      }

      stage('Approval') {
           steps {
                script {
                    env.RELEASE_SCOPE = input message: 'User input required', ok: 'Release!',
                            parameters: [choice(name: 'RELEASE_SCOPE', choices: 'patch\nminor\nmajor', description: 'What is the release scope?')]
                }
                echo "${env.RELEASE_SCOPE}"
                }
      }

      stage('TF Apply') {
        steps {
          echo "${env.RELEASE_SCOPE}"
          sh 'terraform apply -auto-approve'
        }
      }

    
    } 
  }
