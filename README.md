 TERRAFORM
 ![image](https://github.com/j0hncy/Terraform/assets/164562775/da7261e0-1a3b-4606-80da-dc6157aa9aac)
![image](https://github.com/j0hncy/Terraform/assets/164562775/c3f11170-44c3-46ac-b003-ec227fbedb94)
Type ctrl+space in terminal to list all the top level blocks and blocks inside blocks.
Resources have arguments, attributes, and meta-arguments.
•	Arguments configure a particular resource; because of this, many arguments are resource-specific. Arguments can be required or optional, as specified by the provider. If you do not supply a required argument, Terraform will give an error and not apply the configuration.
•	Attributes are values exposed by an existing resource. References to resource attributes take the format resource_type.resource_name.attribute_name. Unlike arguments which specify an infrastructure object's configuration, a resource's attributes are often assigned to it by the underlying cloud provider or API.
•	Meta-arguments change a resource's behavior, such as using a count meta-argument to create multiple resources. Meta-arguments are a function of Terraform itself and are not resource or provider-specific. https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on
 ![image](https://github.com/j0hncy/Terraform/assets/164562775/01ca133c-d1db-41c7-a472-e4f18d5ffdbf)

Terraform Block
 ![image](https://github.com/j0hncy/Terraform/assets/164562775/fab37e8e-432e-4762-adb2-60f5f982929e)
![image](https://github.com/j0hncy/Terraform/assets/164562775/a022232e-8464-4fe6-961b-3229a7d42456)
Terraform registry badges
 ![image](https://github.com/j0hncy/Terraform/assets/164562775/55fcea18-30e2-49b8-85c0-3c936e14f604)
Terraform Backend file will contain the state information of the resources you have provisioned. This details will be stored in a file called terraform.tfstate file. Terraform backend section will tell where this file needs to be saved. If this section is not defined, terraform will store this file in the local system working directory.
Resource Block
 ![image](https://github.com/j0hncy/Terraform/assets/164562775/1bc14f93-ad1d-4005-8657-853178cb43f2)
Terraform state file
A terraform state file will be created in local working directory immediately after executing the terraform apply command. The terraform state file will contain the information about your real infrastructure. For instance the the Ec2 instance details in an AWS cloud. Hence this file is called the database or reference file. If this file is deleted, we cannot confirm the resources in the AWS is a terraform managed resources. Always please note whatever is inside the terraform configuration file (.tf file) is the desired state and whatever is present in the cloud (state file )is the current state.
 ![image](https://github.com/j0hncy/Terraform/assets/164562775/06de5a05-3910-4707-9c54-06d38d43e745)
 ![image](https://github.com/j0hncy/Terraform/assets/164562775/7f93e202-5c37-4498-95ab-5e6b739d5a54)
Provider requirements – Here the source and version are nothing but the one you get from terraform registry url. Screenshot added below. And when you do terraform init it copies provider code with all apis to local working directory at .terraform directory. Refer above fig.
Terraform input variables
 ![image](https://github.com/j0hncy/Terraform/assets/164562775/a6191553-29d6-4d14-bc87-9c10e4707de2)
Terraform Data sources
Data sources   allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
 ![image](https://github.com/j0hncy/Terraform/assets/164562775/c6215629-5d9b-401d-84d1-19d9a96a6a2b)
List and map type variables 
![image](https://github.com/j0hncy/Terraform/assets/164562775/5156bbde-eda2-432b-a741-18887b03fbaa)
![image](https://github.com/j0hncy/Terraform/assets/164562775/afe49cde-cacf-48a7-a8e4-b9a60d58b92b)
If you simple variable to get the instance type, please use line number 1 in above fig.
Instance_type = var.instance_type
But if you use list variable to get the instance type, please use the line number 2 in main .tf file
Instance_type = var.instance_type_list[0]. This will assign t3.micro 
If you use Map variable to get the instance type, please use the line number 3 in main .tf file
Instance_type = var.instance_type_map[qa] This will assign t3 small

How to create multiple resources having same configuration

For this we have to use the “count” meta argument. Meta argument is used to change the behavior of a resource. So using count we could create multiple Ec2 instance with same set of configuration but with different tags. Below conf create 2 Ec2 with Tag : Count-Demo-[0,1]
![image](https://github.com/j0hncy/Terraform/assets/164562775/e4adba57-c35e-4d21-bc84-c6604deec45a)
How to output the instance ids in loop in output
We will be using a for loop in output to get it done.
	For loop with list
Syntax : value = [for <variable> in <resource logical name>: <variable>.<resource attribute>]
	For loop with map
Syntax : value = {for <variable> in <resource logical name>:<variable>.<resource attribute>=> <variable>.<resource attribute>}
	Latest splat operator
Syntax : value = <resource logical name>.[*].<resource attribute>.

 

for_each
In last example we created 2 Ec2 instance in default availability zone. If we want the Ec2 in different availability Zone we can add that argument and mention a Az. But what if we need Ec2 instance in each availability zone. Here comes another meta argument called “for_each”. “for_each” is advanced of count. “for_each” cannot accept a list but only a map or a set of strings and create instance for each item in that map or set.
To convert a list into a set we use “toset” operator in terraform. In below example data.aws_availability_zones.my_azones.names is a list. To convert it into a set we used “toset” operator.
  

Above you see two things each.key and each,value. Consider below example 
resource "azurerm_resource_group" "rg" {
  for_each = {
    a_group = "eastus"
    another_group = "westus2"
  }
  name     = each.key
  location = each.value
}

Here each.key = a_group and each.value = eastus. Similarly in second iteration each.key=another_group and each.value = westus2

Consider below example of a set of strings instead of a map as in the above example

resource "aws_iam_user" "the-accounts" {
  for_each = toset( ["Todd", "James", "Alice", "Dottie"] )
  name     = each.key
}

Here each.key = Todd and each.value = Toadd. Similarly in second iteration each.key=James and each.value = James

 ****************************************
To comment a single line use # or //
To comment multiple line use /* and */
*****************************************
How can you create resources in different cloud using terraform?
 
Here you could see two provider block, once with aws and another one with azure. Same way if you need to create resources in multiple region in AWS use as below.
 
https://github.com/iam-veeramalla/terraform-zero-to-hero

Terraform.tfvars -> Let’s say you have dev, stage and prod environment where you need to create ec2 instance. Type of ec2 is different in each env. In such cases, create file called terraform.tfvars and add the type value as key value pairs.

Conditional resource -> condition? True statement: False Statement

Remote Backend -> We are a devops engineering team of 5 people and we have a git repository where the terraform codes are stored. Before we use Remote backend all devops engineer in the team have to make sure that the state file also uploaded to the git after they clone the repo and update the code. Otherwise the state file will not get updated and create issues. Please note, a state file will generate only when you run “terraform apply” command.  To solve this problem, instead of storing the terraform state file in the git, we use S3 as remote backend to store the state file. Hence each time any devops engineer clone, update and test the code in their local machine the state file automatically updated in a central remote backend (S3).

Command to show the state file content -> terraform show

How to create a S3 remote backend?
Create a file called backend.tf in your home directory and add below 
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
    dynamodb_table=”terraform_lock”
  }
}
NOTE: Here the dynamodb_table will help you to lock the control. Means when you update a resource in AWS using terraform no one else in the team can update the same resource.

Provisioners in Terraform
Provisioners in Terraform are mechanisms used to execute scripts or commands on the local machine or remote resources during resource creation or destruction. They allow you to perform tasks such as bootstrapping, configuration management, or running custom scripts as part of your infrastructure deployment process. Terraform support multiple provisioners. Below are a few.

file Provisioner:
The file provisioner is used to copy files or directories from the local machine to a remote machine. This is useful for deploying configuration files, scripts, or other assets to a provisioned instance.
provisioner "file" {
    source      = "../Deploy-app(provisioner)/app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
    }

remote-exec Provisioner:
The remote-exec provisioner is used to run scripts or commands on a remote machine over SSH or WinRM connections. It's often used to configure or install software on provisioned instances.
  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &",
    ]
  }


Local-exec Provisioner: 
Executes commands or scripts on the machine running Terraform. This is useful for performing tasks that don't require execution on remote resources, such as local setup or configuration.

Ansible provisioner
resource "aws_instance" "example" {
  # Resource configuration...
  provisioner "ansible" {
    playbook_file = "playbook.yml"
  }
}

Terraform workspace

Terraform drift detection
“terraform refresh” command is used to check the drift. You can add this command as cronjob and execute it daily or weekly.
Here's how terraform refresh works:
1.	Query Provider APIs: When you run terraform refresh, Terraform communicates with the provider APIs (e.g., AWS API, Azure API) to fetch the current state of resources that are managed by your Terraform configuration.
2.	Compare State: Terraform compares the information retrieved from the provider APIs with the state information recorded in the Terraform state file.
3.	Update State File: If there are any differences between the current state of resources and the recorded state in the state file, Terraform updates the state file to reflect the latest information.
4.	Output: After the refresh operation completes, Terraform displays a summary of the changes made during the refresh process. This includes any new resources, changes to existing resources, or resources that were removed since the last refresh.
The terraform refresh command is primarily used to synchronize the Terraform state with changes made outside of Terraform, such as manual modifications to resources in the cloud provider's console or changes made by other automation tools.
It's important to note that terraform refresh does not make any changes to the infrastructure itself; it only updates the Terraform state file. To apply any changes detected during the refresh process, you would typically follow up with a terraform plan and terraform apply to enact those changes.


Create a lambda function with the list of services managed by terraform. Integrate this lambda with cloud trail events to check if the modify resource is from an IAM identity. And if yes send a notification to the stakeholders.

You can also use the “terraform plan” command to find the drift. Because it actually check the difference between the state file and the configuration file. Hence a resource gets updated without terraform that changes will not be available in the state file.

Terraform migration using terraform import command.
Step -1 : Create below file  and run the command terraform plan -generate-config-out=<file name>. This will create a file with the details of the resource. But still terraform will not create the terraform.tfstate file. 
 

Step -2: To create the .tfstate file execute the import command
#terraform import aws_instance.example <instance-id>

Interview Questions 

Q. how can we prevent terraform to apply changes few resources from the list?

To prevent Terraform from applying changes to specific resources, you can use the ignore_changes lifecycle attribute within a resource block. This attribute allows you to specify which attributes Terraform should ignore when determining whether a resource needs to be updated.
Here's an example of how you can use ignore_changes to prevent Terraform from applying changes to specific attributes of a resource:
resource "aws_instance" "example" {
  # Resource configuration...

  lifecycle {
    ignore_changes = [
      # List of attributes to ignore changes for
      tags,  # Ignore changes to instance tags
      ami,   # Ignore changes to the AMI ID
      # Add additional attributes as needed
    ]
  }
}

In this example, Terraform will ignore changes to the tags and ami attributes of the aws_instance resource named example. When Terraform performs a plan or apply operation, it will not consider changes to these attributes as updates to the resource.
 
If you want to prevent Terraform from modifying specific resources without changing the existing Terraform files, you can use the -target option with the terraform apply command to specify only the resources you want to modify. By targeting only the resources you want to change, Terraform will ignore any other resources in your configuration.

Q. How to pass the output of one terraform to input to another one automatically?
By using terraform_remote_state, you can automatically pass the output of one Terraform configuration to another without the need for manual intervention or external scripts. This approach helps maintain consistency and automation in your infrastructure deployments.
