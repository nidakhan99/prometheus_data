terraform {
  backend "s3" {
    bucket = "my-tool-buck"
    key    = "Terraform_as4/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "my_tool_dynamo"
  }
}