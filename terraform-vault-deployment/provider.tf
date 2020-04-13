provider "google" {
}

provider "kubernetes" {
  config_path = "config"
  host  = google_container_cluster.kubernetes_cluster.endpoint
  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    config_path = "config"
    host  = google_container_cluster.kubernetes_cluster.endpoint
    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
      google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
    )
  }
}