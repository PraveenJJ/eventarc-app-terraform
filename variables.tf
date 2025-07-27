variable "project_id" {
  type = string
}

variable "project_number" {
  type = string
}

variable "region" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "image_url" {
  type = string
}

variable "static_bucket_name" {
  description = "Name of the bucket to store txt files"
  type        = string
}

variable "firestore_collection" {
  description = "Name of the firestore collection"
  type        = string
}