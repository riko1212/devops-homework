terraform {
  backend "s3" {
    bucket         = "andrii-danylko-terraform-state"
    key            = "final-project/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
