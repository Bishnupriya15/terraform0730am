provider "aws" {
  
}
resource "aws_instance" "name" {
    ami = "ami-05ffe3c48a9991131"
    instance_type = "t2.micro"
    key_name = ""
    tags = {
        Name = "Day4"
    }
  
}
resource "aws_s3_bucket" "name" {
  bucket = "bishnupriyaaterraform"

}