variable "bucket_name" {
  description = "name of the s3 bucket"
  type        = string
  default     = "djtf-state-bucket"
}

variable "vers_status" {
  description = "status of the bucket versioning"
  type        = string
  default     = "Enabled"
}

variable "vpc_cidr" {
  description = "cidr for the vpc"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpc_name" {
  description = "name of the vpc"
  type        = string
  default     = "tfvpc"
}

variable "pub_cidr" {
  description = "public cidr"
  type        = string
  default     = "192.168.1.0/24"
}

variable "pub_cidr_name" {
  description = "public cidr name"
  type        = string
  default     = "tfsubnet1"
}

variable "priv_cidr" {
  description = "private cidr"
  type        = string
  default     = "192.168.2.0/24"
}

variable "priv_cidr_name" {
  description = "private cidr name"
  type        = string
  default     = "tfsubnet2"
}

variable "ig_name" {
  description = "internet gateway name"
  type        = string
  default     = "tfigw"
}

variable "pub_cidr_az" {
  description = "az for public subnet"
  type        = string
  default     = "us-east-2a"
}

variable "priv_cidr_az" {
  description = "az for private subnet"
  type        = string
  default     = "us-east-2b"
}

variable "pub_route_cidr" {
  description = "public routing table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ng_name" {
  description = "nat gateway name"
  type        = string
  default     = "tfngw"
}