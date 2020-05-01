module "vpn_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name                      = "${var.prefix}-vpn"
  image_id                  = data.aws_ami.ubuntu.image_id
  instance_type             = var.instance_type
  security_groups           = [aws_security_group.vpn.id]
  iam_instance_profile      = aws_iam_instance_profile.vpn.name
  asg_name                  = "${var.prefix}-vpn"
  lc_name                   = "${var.prefix}-vpn"
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.public_subnets
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  default_cooldown          = 120
  health_check_grace_period = 120
  key_name                  = var.key_name


  user_data = templatefile("${path.module}/files/vpn_user_data.sh", {
    EIP_ID = aws_eip.vpn.id
    REGION = data.aws_region.current.name
    CONFIG_BUCKET = aws_s3_bucket.configs.id
    WIREGUARD_INTERFACE = var.wireguard_interface
    WIREGUARD_PORT = var.wireguard_vpn_port
  })

  tags_as_map = {
    "Name"      = "${var.prefix}-vpn"
    "App"       = "WireGuard"
    "Terraform" = "true"
  }
}
