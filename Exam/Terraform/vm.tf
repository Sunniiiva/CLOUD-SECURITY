#VM with e2-micro for cost efficiency 

resource "google_compute_instance" "vm" {
  name = "vm"
  machine_type = "e2-micro"
  tags = ["http-server"]
  zone = "europe-north1-a"

  #Connecting to subnet
  network_interface {
  subnetwork = google_compute_subnetwork.initial_subnet.name
     access_config {
       nat_ip = google_compute_address.static_ip.address
     }
  }

  #Disk with linux ubuntu for both security and cost-efficiency

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

#Installing and starting up NGinx server

metadata_startup_script = <<-EOT
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
  EOT
}

#assigns a static ip adress to the VM

resource "google_compute_address" "static_ip" {
  name   = "static-ip"
  region = "europe-north1"
}

