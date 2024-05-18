variable "ami" {
  type = string
  description = "ami of instance"
  default = "ami-02bf8ce06a8ed6092"
}

variable "itype" {
    type = string
    description = "instance type"
    default = "t2.micro"
}

variable "az" {
  type = string
  description = "availability zone"
  default = "us-east-2a"
}

variable "instancename" {
    type = string
    description = "instance name"
}