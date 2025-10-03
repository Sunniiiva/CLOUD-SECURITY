#VPC

resource "google_compute_network" "vpc_network" {
  name = "vpc-network"  
  auto_create_subnetworks = false
}



#Subnet

resource "google_compute_subnetwork" "initial_subnet" {
  name = "initial-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network = google_compute_network.vpc_network.id
  region = "europe-north1"

  #Flow logs

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 1.0
    metadata             = "INCLUDE_ALL_METADATA"
  }
}


#Firewall

resource "google_compute_firewall" "allow_http" {
  name = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}

