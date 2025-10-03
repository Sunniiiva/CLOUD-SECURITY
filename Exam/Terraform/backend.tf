
# SSL configuration

resource "google_compute_ssl_certificate" "ssl_certificate" {
  name        = "self-managed-ssl-cert"
  private_key = file("../config-sky2100/private-key.pem")
  certificate = file("../config-sky2100/certificate.pem")
}


#Instance group for the VM

resource "google_compute_instance_group" "instance_group" {
  name      = "single-instance-group"
  zone      = "europe-north1-a" 
  instances = [google_compute_instance.vm.self_link]

  named_port {
    name = "http"
    port = 80
  }
}


#Backend service 

resource "google_compute_backend_service" "backend" {
  name        = "backend"
  description = "Backend service"
  protocol    = "HTTPS"
  timeout_sec = 10

  backend {
    group = google_compute_instance_group.instance_group.self_link
  }
  security_policy = google_compute_security_policy.cloud_armor.id
  health_checks = [google_compute_health_check.https_health_check.self_link]
}


#health check

resource "google_compute_health_check" "https_health_check" {
  name = "https-health-check"

  https_health_check {
    port = 443
  }
}


#url map

resource "google_compute_url_map" "url_map" {
  name = "url-map"
  default_service = google_compute_backend_service.backend.self_link
} 


#https proxy

resource "google_compute_target_https_proxy" "https_proxy" {
  name   = "https-proxy"
  ssl_certificates = [google_compute_ssl_certificate.ssl_certificate.self_link]
  url_map = google_compute_url_map.url_map.self_link
}


#forwarding rule

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "forwarding-rule"
  target     = google_compute_target_https_proxy.https_proxy.self_link
  port_range = "443"
}
