variable "nsg_inbound_rules" {
  type    = list(any)

}
variable "nsg_outbound_rules" {
  type    = list(string)
  default = []
}
variable "resource_group_name" {
}
variable "prefix" {
}
variable "location" {
}
variable "dns_servers" {
  type    = list(string)
  default = []
}
variable "address_space" {
}
variable "front_end_address_prefix" {
}
variable "back_end_address_prefix" {
}