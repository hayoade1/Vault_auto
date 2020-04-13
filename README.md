# Infrastructure GCP

This is a project to deploy a Vault cluster backed by Consul on Google Cloud to support the [Webblog app](https://gitlab.com/public-projects3/web-blog-demo). This is used as part of the [Webblog app blog](https://tekanaid.com/webblog-app-infrastructure-as-code/).

# Before running Terraform

## Look out for:
- Make sure there is an empty file called `config` and reference it in the provider stanzas as follows under config_path. This forces the K8s provider to use this path instead of looking for it in the default ~/.kube/config. Since the config file is empty, the context doesn't matter. I read a bit more here:  https://www.terraform.io/docs/providers/kubernetes/index.html#file-config
- Make sure to download the helm charts for both Consul and Vault into the `terraform-vault-deployment` folder. I have included them in this repo but you may want to download the latest versions. 

## Change Role for Service Account in GCP
Make sure to grant access to the service account in GCP to create clusterrolebindings. Just change the Role from Editor to Owner use the below
https://cloud.google.com/iam/docs/granting-roles-to-service-accounts

## Create a Cloud DNS Zone
You need to do this manually:
- Create a public zone called public-zone and give it a name. Mine is hashidemos.tekanaid.com
- If your main domain is hosted somewhere other than Google's Cloud DNS, then create NS records for hashidemos.tekanaid.com where your DNS is hosted for the main domain pointing to the NS servers created in Google's Cloud DNS

## Now run terraform or use TFC

# After running Terraform

## Vault Commands

You will need to initiate Vault manually as this is best practice

```shell
export VAULT_ADDR=http://vault.hashidemos.tekanaid.com:8200
vault operator init -key-shares=1 -key-threshold=1
vault operator unseal
vault login
```

Then move to the next step of configuring Vault via Terraform