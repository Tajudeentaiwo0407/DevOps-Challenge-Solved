variable "subnet_ids" {
  type        = list(string)
  default = ["subnet-03aacbed8fdf11c42", "subnet-042a0dae2ee2d68dc", "subnet-0c777d4fb163ba2c0"]
  description = "This connect the subnets using its id "
}

variable "eks_cluster_name" {
  type    = string
  default = "ansible"
}