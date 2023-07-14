terraform {

  backend "s3" {
    bucket         	   = "sprints-state-file"
    key              	   = "state/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
    dynamodb_table = "terraform-up-and-running-locks"

  }

}

