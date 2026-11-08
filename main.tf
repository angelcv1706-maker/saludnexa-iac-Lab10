# 0. Consultar automáticamente la versión más reciente de Python disponible
data "aws_elastic_beanstalk_solution_stack" "python_stack" {
  most_recent = true
  name_regex  = ".*running Python.*"
}

# 1. Crear la aplicación de Elastic Beanstalk
resource "aws_elastic_beanstalk_application" "saludnexa_app" {
  name        = "saludnexa-backend-iac"
  description = "API de SaludNexa desplegada vía Terraform"
}

# 2. Crear el entorno de ejecución
resource "aws_elastic_beanstalk_environment" "saludnexa_env" {
  name                = "saludnexa-env-iac"
  application         = aws_elastic_beanstalk_application.saludnexa_app.name
  
  # Inyectar dinámicamente el nombre encontrado en el paso 0
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.python_stack.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }
}