variable "cluster_name" {
  type = string
}
variable "subnet_name" {
  type = string
}
variable "password" {
  type = string
}
variable "endpoint" {
  type = string
}
variable "user" {
  type = string
}


variable "vm_list" {
  description = "List of VMs to create"
  type = list(object({
    name   = string
    vcpu   = number
    memory = number
  }))
}
