variable "bucketname" {
  description = "name of the s3 bucket"
  type        = string
  default     = "djtf-state-bucket"
}

variable "versstatus" {
  description = "status of the bucket versioning"
  type        = string
  default     = "Enabled"
}