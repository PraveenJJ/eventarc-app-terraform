# resource "google_firestore_database" "default" {
#   name        = "(default)"             # Must be this literal value
#   project     = var.project_id
#   location_id = var.region              # Use existing region variable
#   type        = "FIRESTORE_NATIVE"
# }