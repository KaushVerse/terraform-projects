variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "associate_public_ip" {
  type = bool
}

variable "allocate_elastic_ip" {
  type = bool
}

variable "iam_instance_profile_name" {
  type = string
}


variable "root_volume_size" {
  type = number
}

variable "root_volume_type" {
  type = string
}

variable "encrypt_root_volume" {
  type = bool
}

variable "tags" {
  type = map(string)
}
