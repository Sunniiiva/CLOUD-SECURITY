#Cloud Armor Policy / WAF

resource "google_compute_security_policy" "cloud_armor" {
  name        = "cloud-armor"
  description = "Cloud armour policy as web Application firewall"

  rule {
    action   = "allow"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["0.0.0.0/0"]
      }
    }
  }

 rule {
    action   = "allow" 
    priority = 2147483647

    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }  
  }
}
