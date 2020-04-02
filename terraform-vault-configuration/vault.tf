resource "vault_auth_backend" "example" {
  type = "userpass"
}

resource "vault_policy" "admin_policy" {
  name   = "admins"
  policy = file("policies/admin_policy.hcl")
}

resource "vault_policy" "developer_policy" {
  name   = "developers"
  policy = file("policies/developer_policy.hcl")
}

resource "vault_policy" "operations_policy" {
  name   = "operations"
  policy = file("policies/operation_policy.hcl")
}

resource "vault_mount" "developers" {
  path        = "developers"
  type        = "kv-v2"
  description = "KV2 Secrets Engine for Developers."
}

resource "vault_mount" "operations" {
  path        = "operations"
  type        = "kv-v2"
  description = "KV2 Secrets Engine for Operations."
}

resource "vault_generic_secret" "developer_sample_data" {
  path = "${vault_mount.developers.path}/test_account"

  data_json = <<EOT
{
  "username": "foo",
  "password": "bar"
}
EOT
}

// WebBlog Config

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_role" "webblog" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "webblog"
  bound_service_account_names      = ["webblog"]
  bound_service_account_namespaces = ["webblog"]
  token_ttl                        = 86400
  token_policies                   = ["webblog"]
}

resource "vault_policy" "webblog" {
  name   = "webblog"
  policy = file("policies/webblog_policy.hcl")
}

resource "vault_mount" "internal" {
  path        = "internal"
  type        = "kv-v2"
  description = "KV2 Secrets Engine for WebBlog MongoDB."
}

resource "vault_generic_secret" "webblog" {
  path = "${vault_mount.internal.path}/webblog/mongodb"

  data_json = <<EOT
{
  "username": "root",
  "password": "GGhJxUpAB23"
}
EOT
}