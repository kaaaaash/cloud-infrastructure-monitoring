terraform {
  backend "s3" {
    bucket = "cloud-monitoring-tfstate-kaash"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}