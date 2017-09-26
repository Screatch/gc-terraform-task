# Configure the AWS Provider
provider "aws" {
  shared_credentials_file = "/Users/vitaliraikov/Projects/grabcad/.credentials"
  region     = "eu-west-1"
}