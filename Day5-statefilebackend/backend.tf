terraform {
  backend "s3" {
    bucket = "bishnupriyatfbucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
