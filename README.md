# Infrastructure GCP

This is a project to deploy infrastructure on Google Cloud

## Look out for:
For some reason it sometimes doesn't like my ~.kube/config file to contain `current-context: ` line. So delete that before running terraform apply.

## Change Role for Service Account in GCP
Make sure to grant access to the service account in GCP to create clusterrolebindings. Just change the Role from Editor to Owner use the below
https://cloud.google.com/iam/docs/granting-roles-to-service-accounts

## Create a Cloud DNS Zone
You need to do this manually:
- Create a public zone called public-zone and name it hashidemos.tekanaid.com
- Create NS records for hashidemos.tekanaid.com in Digital Ocean pointing to the NS servers created in Google's Cloud DNS

## Vault Commands

```shell
export VAULT_ADDR=http://vault.hashidemos.tekanaid.com:8200
vault operator init -recovery-shares=1 -recovery-threshold=1
vault operator unseal
vault login
```

You can check the secrets.md file for the unseal keys and root token

Then run terraform apply in the configuration folder