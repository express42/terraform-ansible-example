# Overview
Quick start on how to provision with ansible using terraform (remote) state file.

## Project structure
* ansible - folder with ansible playbooks, inventories and configuration
* terraform - folder with terraform infrastructure files
* packer - folder with packer image definition

## Getting stated
You'll need to have AWS credentials. By default you can find it in  ~/.aws/credentials:
```sh
$ cat ~/.aws/credentials
[default]
aws_access_key_id = <AWS_ACCESS_TOKEN>
aws_secret_access_key = <AWS_SECRET_ACCESS_KEY>
...
```
Create the base AWS AMI using packer (if you don't have one in the storage):
```sh
$ cd packer
$ packer validate ubuntu-16.04-amd64-example.json
$ packer build ubuntu-16.04-amd64-example.json
```
## Usage
If you want just to run example infrastructure, create terraform.tfvars file from template terraform.tfvars.example and set your variables:
```sh
$ cd ../terraform
$ cp terraform.tfvars.example terraform.tfvars
```
(Optional) Create backend.tf file from template and set your backend configs:
```sh
$ cp backend.tf.example backend.tf
```
Initialize terraform configuration:
```sh
$ terraform init
```

(Optional) Check the plan of your infrastructure:
```sh
$ terraform plan
```

Create all resources:
```sh
$ terraform apply
```

Provision services:
```sh
$ cd ../ansible
$ ansible-playbook -i dynamic_inventory.sh playbooks/db.yml -e env="your_env"
$ ansible-playbook -i dynamic_inventory.sh playbooks/web.yml -e env="your_env"
```

Delete all created resources:
```sh
$ terraform destroy
```
# Terraform structure

#### main.tf - contain general infrastructure description
We describe used provider, can create resources, call modules:
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

Variables can be defined in variables.tf or any other .tf file:
```
  variable env {
    description = "current environment (dev, prod, stage)"
    default = "dev"
  }
```
You can just create it but not define in .tf file, but then you'll need to define it anywhere:
  ```
    variable "name" {}
  ```

* terraform.tfvars (default) or any other .tfvars file with flag -var-file
```sh
$ terraform plan \
  -var-file="secret.tfvars" \
  -var-file="production.tfvars"
```
* input argument to terraform with flag -var
```sh
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

## Links:
* [Terraform documentation](https://www.terraform.io/docs/ "Terraform documentation")
* [Ansible documentation](https://docs.ansible.com/ansible/index.html "Ansible documentation")
