variable "region_short_name" {
  description = "Defining the region short name for naming convention"
  type = string
  default = "cc"
}

variable "env" {
  description = "Defining the env to differentiate the values"
  default = "lab"
}

variable "website" {
  description = "Describing the website for intact application"
  default = "servus"
}