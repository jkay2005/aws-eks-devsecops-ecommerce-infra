variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) && can(regex("/16$", var.vpc_cidr))
    error_message = "vpc_cidr must be an IPv4 /16 CIDR."
  }
}

variable "availability_zones" {
  type = list(string)

  validation {
    condition     = length(var.availability_zones) == 2 && length(distinct(var.availability_zones)) == 2
    error_message = "Provide exactly two distinct availability zones."
  }
}

variable "tags" {
  type = map(string)
}
