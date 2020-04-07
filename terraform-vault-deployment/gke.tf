resource "google_container_cluster" "kubernetes_cluster" {
  name     = var.cluster_name
  project  = var.project
  location = var.location
  remove_default_node_pool = true
  initial_node_count = 1
  network            = var.network

}

resource "google_container_node_pool" "primary_nodepool" {
  name       = var.nodepool_name
  project    = var.project
  location   = var.location
  cluster    = google_container_cluster.kubernetes_cluster.name
  node_count = var.nodepool_node_count


  node_config {
    machine_type = var.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      DoNotDelete = "True"
    }

    tags = ["DoNotDelete", "SamG"]

  }
}