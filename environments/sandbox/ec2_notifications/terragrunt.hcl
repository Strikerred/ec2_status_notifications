
# sandbox/ec2_notifications/terragrunt.hcl
locals {
  repo_path = run_cmd("git", "rev-parse", "--show-toplevel")
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.repo_path}/services//ec2_notifications"
}

inputs = {
  environment          = "sandbox"
  aws_region           = "us-west-2"
  service_name         = "ec2_notifications"
  department           = "tech delivery"
  instance_id          = ["i-095137f8fxxxxxx", "i-xxxxxxxb80f494"]
  security_group_id    = ["sg-02d8d03xxxxxxd85"]
  network_interface_id = ["eni-08f42dxxxxxxc4a0", "eni-091fxxxxxxe720b"]
  eni_attachment_id    = ["eni-attach-0671ff01e10b2df46", "eni-attach-xxxxxxfb0e1553"]
  eip_association_id   = ["eipassoc-046xxxxxx5dd3e8"]
}
    
