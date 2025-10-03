#Snapshot Automated Backups

resource "google_compute_resource_policy" "snapshot" {
  name   = "daily-snapshot"
  region = "europe-north1"

  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "12:00"
     }
   }
    retention_policy {
      max_retention_days = 7
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
  }
}
