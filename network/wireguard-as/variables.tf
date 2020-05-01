variable "prefix" {
  default = "wireguard"
  description = "String to use as a prefix when naming resources"
}

variable "domain_name" {
  description = "Domain name to use for setting up Route 53 records"
}

variable "instance_type" {
  default = "t3.small"
  description = "EC2 instance type to provision for VPN server"
}

variable "key_name" {
  description = "Key pair to use for provisioning EC2 instance"
}

variable "vpn_access_cidrs" {
  default = ["0.0.0.0/0"]
  description = "IP addresses which should be able to connect to the VPN"
  type = list
}

variable "management_access_cidrs" {
  default = []
  description = "IP addresses which should be able to reach the administrative interfaces (web/ssh)"
  type = list
}

variable "wireguard_vpn_port" {
  default = 51820
  description = "Port to use for WireGuard VPN (udp)"
}

variable "vpc_id" {
  description = "ID of the VPC to deploy network resources into"
}

variable "public_subnets" {
  description = "List of subnets for deploying WireGuard VPN servers into"
}

variable "wireguard_interface" {
  default = "10.66.66.1/24"
  description = "VPN tunnel interface IP and CIDR"
}
