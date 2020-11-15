provider "alicloud" {
region           = "cn-hangzhou"
}

variable "env" {
  type = string
}
variable "number_of_instances" {
  type = string
}

resource "alicloud_vpc" "vpc" {
  name       = "tf_test_foo"
  cidr_block = "172.16.0.0/12"
}

resource "alicloud_vswitch" "vsw" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "172.16.0.0/21"
  availability_zone = "cn-hangzhou-b"
}

resource "alicloud_security_group" "default" {
  name   = "default"
  vpc_id = alicloud_vpc.vpc.id
}

module "tf-instances" {
  source = "alibaba/ecs-instance/alicloud"
  vswitch_id = alicloud_vswitch.vsw.id
  security_group_ids = alicloud_security_group.default.*.id
  region = "cn-hangzhou"
  disk_category = "cloud_efficiency"
  image_id                   = "centos_7_8_x64_20G_alibase_20200914.vhd"
  instance_name = format("%s_my_module_instances_", var.env)
  instance_type              = "ecs.n2.small"
  host_name = "sample"
  internet_charge_type = "PayByTraffic"
  number_of_instances = var.number_of_instances
  password="User@123"
  user_data=file("init.sh")
  associate_public_ip_address = true
  internet_max_bandwidth_out  = 10
  tags = {
    Created      = "Terraform"
    Environment = var.env
  }


}
resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_oss_bucket" "bucket-acl"{
  bucket = "wangkai-test-2020"
  acl = "private"
}
