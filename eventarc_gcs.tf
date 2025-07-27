resource "google_service_account" "eventarc_trigger_gcs_sa" {
  account_id   = "eventarc-trigger-gcs-sa"
  display_name = "Eventarc Trigger GCS Service Account"
}

resource "google_project_iam_member" "eventarc_trigger_gcs_sa_event_receiver" {
  role   = "roles/eventarc.eventReceiver"
  project = var.project_id
  member = "serviceAccount:${google_service_account.eventarc_trigger_gcs_sa.email}"
}

resource "google_project_iam_member" "eventarc_trigger_gcs_sa_run_invoker" {
  role   = "roles/run.invoker"
  project = var.project_id
  member = "serviceAccount:${google_service_account.eventarc_trigger_gcs_sa.email}"
}

resource "google_project_iam_member" "storage_service_agent_pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:service-${var.project_number}@gs-project-accounts.iam.gserviceaccount.com"
}

resource "google_pubsub_topic" "eventarc_trigger_gcs_topic" {
  name = "eventarc-trigger-gcs-topic"
}

resource "google_eventarc_trigger" "eventarc_trigger_gcs_finalized" {
  name     = "eventarc-trigger-gcs-finalized"
  location = var.region

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.storage.object.v1.finalized"
  }

  matching_criteria {
    attribute = "bucket"
    value     = var.static_bucket_name
  }

  service_account = google_service_account.eventarc_trigger_gcs_sa.email

  destination {
    cloud_run_service {
      service = var.service_name
      region  = var.region
      path    = "/tmsgis/loader/process"
    }
  }
  
}
