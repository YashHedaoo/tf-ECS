terraform {
  backend "s3" {
    bucket         = "yash-ecs-oneagent-tfstate"
    key            = "ecs-oneagent/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
