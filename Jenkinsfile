
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
            def INPUT_PARAMS = input message: 'Please select option', ok: 'Next',
                            parameters: [ 
                            choice(name: 'TERRAFORM', choices: ['apply','destroy','exit'].join('\n'), description: 'Please select the option'),
                            ])
          }
        }
      }

      stage('TF Apply') {
        steps {
          sh 'echo $TERRAFORM'  
          sh 'terraform apply -auto-approve'
        }
      }
    } 
  }
