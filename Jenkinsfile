pipeline {
    agent any

    environment {
        TF_CLI_ARGS = '-no-color'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    withCredentials([aws(credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform init'
                        echo 'Running Terraform plan'
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { env.BRANCH_NAME == 'main' }
                expression { currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause) != null }
            }
            steps {
                script {
        //             // Ask for manual confirmation before applying changes
                    input message: 'Do you want to apply changes?', ok: 'Yes'
                    withCredentials([aws(credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform init'
                        echo 'Running Terraform apply'
                        sh 'terraform apply tfplan'
                    }
                }
            }
        }
        stage('Lint Code') {
            steps {
                script { 
                    echo 'Linting Terraform configurations...'
                    sh 'terraform validate'
                    echo 'Terraform configurations validated'
                }
            }
        }
    
        }
    }
    post {
    always {
        stage('Cleanup') {
            steps {
                script {
                    echo 'Performing cleanup....'
                    sh 'rm -rf tfplan' // cleanup comand to remove plan file
                    echo 'Cleanup completed'
                }
            }
        }
    }
    }


