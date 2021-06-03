variable "ami" {
  type = map

  default = {
    "us-east-2" = "ami-0e82959d4ed12de3f"
  }
}

variable "builder_instance_count" {
  default = "1"
}

variable "prod_instance_count" {
  default = "2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "us-east-2"
}

variable "app_name" {
  default = "red5"
}
