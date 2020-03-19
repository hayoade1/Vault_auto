terraform {
  backend "remote" {
    organization = "HashiCorp-Sam"

    workspaces {
      name = "infrastructure-gcp-tf-vault-deployment"
    }
  }
}


provider "google" {
  // credentials = file("/Users/sam/.gcloud/gcloudSecretsHashiCorp/sam-gabrail-gcp-demos-8770826913f1.json")
}

provider "kubernetes" {
  host  = google_container_cluster.kubernetes_cluster.endpoint
  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = google_container_cluster.kubernetes_cluster.endpoint
    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
      google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
    )
  }
}