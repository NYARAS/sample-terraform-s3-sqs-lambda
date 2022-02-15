provider "aws" {
  region = var.region
  profile = "personal-deployment" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
}
