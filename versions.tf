terraform {
  required_version = ">= 1.1.2, < 2.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.59, < 5.0"
    }
  }
}
