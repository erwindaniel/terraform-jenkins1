
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
                    env.OPTION_TERRAFORM = input message: 'User input required', ok: 'Execute!',
                            parameters: [choice(name: 'OPTION_TERRAFORM', choices: 'apply\ndestroy', description: 'Apply or destroy infraestrcture?')]
                }
                echo "${env.OPTION_TERRAFORM}"
                }
      }

      stage('TF Apply-Destroy') {
        steps {
          echo "${env.OPTION_TERRAFORM}"
          sh "terraform ${env.OPTION_TERRAFORM} -auto-approve"
        }
      }

    
    } 
  }
