# Provision [EventStore](https://geteventstore.com) with [Terraform](https://www.terraform.io/)

Quick [Terraform v0.6.6](https://www.terraform.io/) configuration to setup [EventStore v3.3.0](https://geteventstore.com) in single-node running on ubuntu 15.10 in any public AWS region.

## Running 

Create a ```terraform.tfvars``` file with the following content.

```
aws_access_key = "<your access key>"
aws_secret_key = "<your secret key>"
aws_region = "<region - e.g. ap-southeast-2>"
aws_key_pair = "<your keypair for that region>"
```


Run 

```
make
```
