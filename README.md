# Infrastructure GCP

This is a project to deploy infrastructure on Google Cloud

# Before running Terraform

## Look out for:
Make sure there is an empty file called `config` and reference it in the provider stanzas as follows under config_path. This forces the K8s provider to use this path instead of looking for it in the default ~/.kube/config. Since the config file is empty, the context doesn't matter. I read a bit more here:  https://www.terraform.io/docs/providers/kubernetes/index.html#file-config

## Change Role for Service Account in GCP
Make sure to grant access to the service account in GCP to create clusterrolebindings. Just change the Role from Editor to Owner use the below
https://cloud.google.com/iam/docs/granting-roles-to-service-accounts

## Create a Cloud DNS Zone
You need to do this manually:
- Create a public zone called public-zone and name it hashidemos.tekanaid.com
- Create NS records for hashidemos.tekanaid.com in Digital Ocean pointing to the NS servers created in Google's Cloud DNS

## Now run terraform or use TFC

# After running Terraform

## Vault Commands

```shell
export VAULT_ADDR=http://vault.hashidemos.tekanaid.com:8200
vault operator init -key-shares=1 -key-threshold=1
vault operator unseal
vault login
```

You can check the secrets.md file for the unseal keys and root token

Then run terraform apply in the configuration folder