# Eventarc Triggers Setup for Cloud Storage and Firestore Events

This repository provides an automated setup for Eventarc triggers on Google Cloud Storage and Firestore events using Terraform and Java Spring Boot REST APIs.

---

## Prerequisites

- **Java Spring Boot REST APIs**  
    Design two REST POST APIs using Java Spring Boot.  
    Reference: [eventarc-app](https://github.com/PraveenJJ/eventarc-app)

- **Google Cloud CLI**  
    Download and install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install).

- **Terraform**  
    Download [Terraform (AMD64)](https://www.terraform.io/downloads.html), extract the ZIP, and move `terraform.exe` to `C:\terraform`.  
    Add `C:\terraform` to your system `PATH` environment variable.

- **Docker Desktop**  
    Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/). Ensure the Docker engine is running.

---

## Instructions

### 1. Create Artifact Registry

Authenticate with Google Cloud CLI:

```sh
gcloud auth application-default login
```

Create a folder for your Terraform scripts and add the script to create an Artifact Registry repository for Docker.

Enable the Artifact Registry API:

```sh
gcloud services enable artifactregistry.googleapis.com
```

Initialize and apply Terraform:

```sh
terraform init
terraform apply
# Type 'yes' when prompted
```

This will create a Docker Artifact Registry in GCP.

---

### 2. Build and Push Docker Image to Artifact Registry

Package the application:

```sh
mvn clean package
```

Build the Docker image:

```sh
docker build -t eventarc-app:latest .
```

Authenticate Docker with GCP:

```sh
gcloud auth configure-docker us-east1-docker.pkg.dev
```

Tag the Docker image:

```sh
docker tag eventarc-app:latest us-east1-docker.pkg.dev/hallowed-valve-466712-m0/eventarc-app-docker-repo/eventarc-app:latest
```

Push the Docker image:

```sh
docker push us-east1-docker.pkg.dev/hallowed-valve-466712-m0/eventarc-app-docker-repo/eventarc-app:latest
```

---

### 3. Deploy Docker Image to Cloud Run

Create the Terraform script for Cloud Run.

Enable the Cloud Run API:

```sh
gcloud services enable run.googleapis.com
```

Deploy using Terraform:

```sh
terraform plan
terraform apply
# Type 'yes' when prompted
```

After deployment, the Cloud Run service URL will be visible in the GCP Console. Test the service using [Postman](https://www.postman.com/).

---

### 4. Create Cloud Storage Bucket

Create the Terraform script for Cloud Storage.

No need to manually enable Cloud Storage; it is enabled by default.

Apply Terraform:

```sh
terraform plan
terraform apply
# Type 'yes' when prompted
```

Upload sample files via the GCP Console and access them using the public URL.

---

### 5. Create Firestore Database

Enable the Firestore API via the GCP Console.

> **Note:** Creating Firestore databases using Terraform scripts is not fully supported. Use the GCP Console for this step.

In the Firestore Console:
- Click **Start Collection**
- Enter a collection name (e.g., `users`)
- Add a field (e.g., `name: jack`)
- Click **SAVE**

---

### 6. Create Eventarc Trigger for Cloud Storage

Create the Terraform script for the Eventarc trigger.

Enable the Eventarc API via the GCP Console.

Apply Terraform:

```sh
terraform plan
terraform apply
# Type 'yes' when prompted
```

Verify the trigger under **Cloud Run > Service > Triggers**.  
Uploading a new file to Cloud Storage will trigger an API call to the Cloud Run service.

---

### 7. Create Eventarc Trigger for Firestore

> **Note:** Creating Eventarc triggers for Firestore using Terraform is not fully supported. Use the GCP Console for this step.

After creating the trigger, verify it under **Cloud Run > Service > Triggers**.

To test:
- In Firestore Console, under the `users` collection, add a document (e.g., `name: julie`)
- Click **SAVE**
- This will trigger an API call to the Cloud Run service.

---

## Summary

This guide automates the setup of Eventarc triggers for Cloud Storage and Firestore using Terraform and Java Spring Boot APIs, enabling seamless event-driven workflows on Google Cloud Platform.