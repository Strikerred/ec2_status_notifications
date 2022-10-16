
    # sandbox/ec2_notifications/terragrunt.hcl
    locals{
        repo_path = run_cmd("git", "rev-parse","--show-toplevel")
    }

    include "root" {
        path = find_in_parent_folders()
    }
    
    terraform {
        source = "${local.repo_path}/services//ec2_notifications"
    }
    
    inputs = {
        environment = "sandbox"
        aws_region = "us-west-2"
        service_name = "ec2_notifications"
        department = "tech delivery"
    }
    