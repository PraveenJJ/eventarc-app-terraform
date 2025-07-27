resource "google_service_account" "eventarc_trigger_firestore_sa" {
  account_id   = "eventarc-trigger-firestore-sa"
  display_name = "Eventarc Trigger Firestore Service Account"
}

# Allow Eventarc to use the service account
resource "google_project_iam_member" "firestore_sa_event_receiver" {
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.eventarc_trigger_firestore_sa.email}"
}

# Allow Cloud Run to be invoked by this SA
resource "google_project_iam_member" "firestore_sa_run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.eventarc_trigger_firestore_sa.email}"
}

resource "google_eventarc_trigger" "eventarc_trigger_firestore_written" {
  name     = "eventarc-trigger-firestore-written"
  location = var.region

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.firestore.document.v1.written"
  }

  matching_criteria {
    attribute = "database"
    value     = "projects/${var.project_id}/databases/(default)"
  }

  matching_criteria {
    attribute = "document"
    value     = "projects/${var.project_id}/databases/(default)/documents/${var.firestore_collection}/{docId}"
  }

  service_account = google_service_account.eventarc_trigger_firestore_sa.email

  event_data_content_type = "application/protobuf"

  destination {
    cloud_run_service {
      service = var.service_name
      region  = var.region
      path    = "/tmsgis/geohash/event"
    }
  }
}
