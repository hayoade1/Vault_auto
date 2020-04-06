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

// resource "vault_kubernetes_auth_backend_config" "kubernetes_config" {
//   kubernetes_host    = "https://$KUBERNETES_PORT_443_TCP_ADDR:443"
//   kubernetes_ca_cert = "@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
//   token_reviewer_jwt = "$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
// }

// You could use the above stanza to configure the K8s auth method by providing the proper values or do this manually inside the Vault container:
// vault write auth/kubernetes/config \
//         token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
//         kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
//         kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

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
  "username": "${var.DB_USER}",
  "password": "${var.DB_PASSWORD}"
}
EOT
}

resource "vault_mount" "db" {
  path = "mongodb"
  type = "database"
  description = "Dynamic Secrets Engine for WebBlog MongoDB."
}

resource "vault_database_secret_backend_connection" "mongodb" {
  backend       = vault_mount.db.path
  name          = "mongodb"
  allowed_roles = ["mongodb-role"]

  mongodb {
    connection_url = "mongodb://${var.DB_USER}:${var.DB_PASSWORD}@${var.DB_URL}/admin"
    
  }
}

resource "vault_database_secret_backend_role" "mongodb-role" {
  backend             = vault_mount.db.path
  name                = "mongodb-role"
  db_name             = vault_database_secret_backend_connection.mongodb.name
  default_ttl         = "10"
  max_ttl             = "86400"
  creation_statements = ["{ \"db\": \"admin\", \"roles\": [{ \"role\": \"readWriteAnyDatabase\" }, {\"role\": \"read\", \"db\": \"foo\"}] }"]
}
