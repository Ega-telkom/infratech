variable "image_tag" {
  type        = string
  description = "Tag atau Commit SHA untuk Docker image"
  default     = "latest"
}

variable "aws_region" {
  type        = string
  description = "AWS Region utama"
  default     = "us-east-1"
}

variable "monitoring_region" {
  type        = string
  description = "AWS Region untuk monitoring"
  default     = "us-west-2"
}
