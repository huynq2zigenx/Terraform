# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnetwork" {
  name          = "my-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region       = var.region
  network      = google_compute_network.vpc_network.name
}

# Firewall Rule for Allowing HTTP
resource "google_compute_firewall" "http_firewall" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80","22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Compute Engine Instance
resource "google_compute_instance" "app_instance" {
  count        = 2
  name         = "app-instance-${count.index}"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnetwork.name

    access_config {
      # Ephemeral IP
    }
  }
}

# Load Balancer
resource "google_compute_global_address" "default" {
  name = "global-ip"
}

resource "google_compute_backend_service" "default" {
  name        = "app-backend"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_health_check.http_health_check.self_link]

  backend {
    group = google_compute_instance_group.app_instance_group.self_link
  }
}

resource "google_compute_instance_group" "app_instance_group" {
  name        = "app-instance-group"
  zone        = var.zone
  instances   = google_compute_instance.app_instance[*].self_link
}

resource "google_compute_url_map" "default" {
  name            = "url-map"
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_target_http_proxy" "default" {
  name   = "http-proxy"
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_global_forwarding_rule" "default" {
  name                = "http-forwarding-rule"
  target              = google_compute_target_http_proxy.default.self_link
  port_range          = "80"
  ip_address      = google_compute_global_address.default.address
}

# Cloud SQL Instance
resource "google_sql_database_instance" "my_sql_instance" {
  name             = "my-sql-instance"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      authorized_networks {
        name  = "my-network"
        value = "0.0.0.0/0"
      }
    }
  }
}

# Cloud Storage Bucket
resource "google_storage_bucket" "my_bucket" {
  name     = "${var.project_id}-bucket"
  location = var.region
}

# Health Check
resource "google_compute_health_check" "http_health_check" {
  name                = "http-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port = 80
    request_path = "/"
  }
}