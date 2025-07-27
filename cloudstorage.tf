resource "google_storage_bucket" "static_txt_bucket" {
  name     = var.static_bucket_name
  location = var.region
  force_destroy = true  # Allows deleting bucket with files inside

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.static_txt_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}