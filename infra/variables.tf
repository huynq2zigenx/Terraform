variable "gcp_svc_key" {
  description = "Path to the GCP service account key file"
  type        = string
}

variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to deploy resources"
  type        = string
  default     = "us-central1-a"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "my-subnet"
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vm_name" {
  description = "The name of the VM instance"
  type        = string
  default     = "my-vm"
}

variable "machine_type" {
  description = "The machine type for the VM instance"
  type        = string
  default     = "e2-micro"
}

variable "vm_image" {
  description = "The image to use for the VM instance"
  type        = string
  default     = "debian-cloud/debian-10"
}

variable "bucket_name" {
  description = "The name of the Cloud Storage bucket"
  type        = string
}

variable "bucket_location" {
  description = "The location of the Cloud Storage bucket"
  type        = string
  default     = "US"
}

variable "lb_name" {
  description = "The name prefix for Load Balancer resources"
  type        = string
  default     = "my-lb"
}

variable "support_email" {
  description = "Support email for IAP brand"
  type        = string
}

variable "iap_user_email" {
  description = "User email for IAP access"
  type        = string
}