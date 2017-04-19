# terraform-ansible-example
Quick start on how to provision with ansible inside terraform

## Project structure
* ansible - folder with ansible playbooks, inventories and configuration
* terraform - folder with terraform infrastructure files

## Getting stated
Prepend environment for using ansible dynamic inventory with Amazon ec2:
```
$ pip install boto
$ chmod +x ansible/ec2.py
```
Of course, you'll need to have AWS credentials. By default you can find it in  ~/.aws/credentials
```
$ cat ~/.aws/credentials
[default]
aws_access_key_id = <AWS_ACCESS_TOKEN>
aws_secret_access_key = <AWS_SECRET_ACCESS_KEY>
...
```

In file ansible/ec2.ini define your regions:
```
...
regions = eu-central-1
regions_exclude = us-gov-west-1, cn-north-1
...
```

## Usage
if you want just up example infrastructure you need set your variables in .tfvars files
```
pub_key_path = "~/.ssh/express42.pub"
private_key_path = "~/.ssh/express42"
key_name = "astarostenko"
env = "astarostenko"
```

Go to terraform folder and download all modules to .terraform folder (for local modules it just creates symlinks)
```
$ cd terraform
$ terraform get
```

If your want to see plan of your own infrastructure

```
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.aws_ami.image: Refreshing state...
The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

+ null_resource.ansible_db

+ null_resource.ansible_web

+ module.db.aws_instance.db
...
...
...
Plan: 9 to add, 0 to change, 0 to destroy.

```
To create all resources and provision all services
```
$ terraform apply
```
To delete all created resources
```
$ terraform destroy
```
# Terraform structure

#### main.tf - contain general infrastructure description
We describe used provider, can create resources, call some modules, and can also define provision  
action
```
provider "aws" {
  region = "${var.region}"
}
...
module "base_linux" {
  source = "./modules/base"
}
...
resource null_resource "ansible_web" {
  depends_on = ["module.web"]

  provisioner "local-exec" {
    command = "cd ../ansible && ansible-playbook playbooks/apache.yml -e env=${var.env} -e group_name=${var.web_server_params["name"]}"
  }
}
...
```


#### variables.tf - define all required variables, its description(optional) default values(optional)

There are three types of variables in terraform:

* string
```
variable "string_var_name" {
    default = "string_value"
}
```
* map
```
variable "map_var_name" {
    default = {
      key-1 = "image-1234"
      key-2 = "image-4567"
}
```
* list
```
variable "list_var_name" {
    default = ["us-east-1a", "us-east-1b"]
}
```

Variables can be defined in
* variables.tf or any other .tf file
```
  variable env {
    description = "current environment (dev, prod, stage)"
    default = "dev"
  }
```
You can just create it but not define in .tf file, but then you'll need to define it anywhere
  ```
    variable "name" {}
  ```

* terraform.tfvars (default) or any other .tfvars file with flag -var-file
```
$ terraform plan \
  -var-file="secret.tfvars" \
  -var-file="production.tfvars"
```
* input argument to terraform with flag -var
```
$ terraform plan -var 'access_key=foo'
```

[More information about variables](https://www.terraform.io/docs/configuration/variables.html)

#### outputs.tf - define all important output data like variables

```
output "web_address" {
  value = "${module.web.public_ip}"
}
```

#### modules/
Modules are used in Terraform to modularize and encapsulate groups of resources in your infrastructure.
Every module is a little terraform project - it can contain its own variables and outputs

Module structure:
* base - module used in every infrastructure
* key_pair - upload public keys to cloud provider
* db - build database resources
* web - build web-service resources

We can use module just like:
```
  module "exemplar_name" {
    source ./modules/web
    name = server_name
    env = "${var.env_name}"
  }
```
[More information about modules](https://www.terraform.io/docs/modules/index.html)
