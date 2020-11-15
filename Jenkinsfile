pipeline {
agent {
    node {
        label 'helm'
    }
}
  environment {
    ALICLOUD_REGION="cn-hangzhou"
    ALICLOUD_ACCESS_KEY = credentials("ALICLOUD_ACCESS_KEY")
    ALICLOUD_SECRET_KEY = credentials("ALICLOUD_SECRET_KEY")
    TERRAFORM_HOME = "/root/terraform"
  }
  stages {
    stage("Source") {
      steps {
        git branch: 'master', credentialsId: 'pengfei.xu', url: 'https://gitlab.daocloud.cn/kai.wang/aliyun-terraform-simple1.git'
        }
    }
    stage('Terraform Init') {
      steps {
        sh "${env.TERRAFORM_HOME}/terraform init -input=false"
      }
    }
    stage('Terraform Select Workspace'){
      steps {
        sh "${env.TERRAFORM_HOME}/terraform workspace new ${params.TF_VAR_env}|| exit 0"
        sh "${env.TERRAFORM_HOME}/terraform workspace select ${params.TF_VAR_env}"
      }
    }
    stage('Terraform Plan') {
      steps {
        sh "${env.TERRAFORM_HOME}/terraform plan -out=tfplan -input=false"
      }
    }
    stage('Terraform Apply') {
      steps {
        input 'Apply Plan'
        sh "${env.TERRAFORM_HOME}/terraform apply -input=false -auto-approve tfplan"
      }
    }
  }
}

