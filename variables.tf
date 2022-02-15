variable "region" {
    default = "eu-west-1"
    description = "AWS Region to deploy to"
}

variable "app_env" {
    default = "calvine"
    description = "Common prefix for all Terraform created resources"
}
