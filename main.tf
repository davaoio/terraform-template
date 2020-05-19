provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

terraform {
  backend "remote" {
    organization = "example"
    workspaces {
      name = "example"
    }
  }
}
