variable "name" {
    description = "resource name prefix"
    type        = string
    default     = "tf"
}

variable "env" {
    description = "environment name prefix"
    type        = string
    default     = "dev" 
}

variable "vpc_cidr" {
    description = "cidr block"
    type        = string
}

variable "subnet_cnt" {
    description = "subnet count"
    type        = number
}

variable "az_list" {
    type    = list(string)
    default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"] 
}

variable "az_list2" {
    type    = list(string)
    default = ["1a", "1c", "1d"]
}