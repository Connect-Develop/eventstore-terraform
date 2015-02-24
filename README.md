# Provision [EventStore](https://geteventstore.com) with [Terraform](https://www.terraform.io/)

Quick [Terraform v0.3.6](https://www.terraform.io/) configuration to setup [EventStore](https://geteventstore.com) in single-node running on ubuntu 15.04 in ap-southeast-2.

## Running 

Create a ```terraform.tfvars``` file with the following content.

```
aws_access_key = "<your access key>"
aws_secret_key = "<your secret key>"
aws_region = "<region - ami is ap-southeast-2 only right now>"
aws_key_pair = "<your keypair for that region>"
```


Run 

```
make
```
