variable "clustername" {
  type    = string
  default = "Ansible"
}

variable "nodegroupname" {
  type    = string
  default = "cluster-nodes"
}

variable "subnet_ids" {
  type        = list(string)
  default = [ "subnet-03aacbed8fdf11c42", "subnet-042a0dae2ee2d68dc", "subnet-0c777d4fb163ba2c0" ]
  description = " Subnets serving this application"
}