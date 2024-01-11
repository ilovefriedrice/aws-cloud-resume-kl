terraform {
  required_providers {
    aws = {
        version = ">4.9.0"
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
    profile = "" /* need to setup profile */ 
    access_key = "" /*OR SETUP IAM USER */
    secret_key = ""
    region = "us-east-1"
  
}