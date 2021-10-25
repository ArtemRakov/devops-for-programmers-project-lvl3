terraform {
  backend "remote" {
    organization = "arakov"

    workspaces {
      name = "hexlet-project"
    }
  }
}

