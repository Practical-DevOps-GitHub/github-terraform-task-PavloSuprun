terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.0.0"
    }
  }
}

provider "github" {
  token = "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" # PAT
  owner = "Practical-DevOps-GitHub" 
}

data "github_repository" "repo" {
  name = "github-terraform-task-mdNikolaichuk" 
}

resource "github_repository_collaborator" "collaborator" {
  repository = data.github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}

resource "github_branch" "develop" {
  repository   = data.github_repository.repo.name
  branch       = "develop"
  source_branch = "main"
  default      = true
}

resource "github_branch_protection" "main" {
  repository_id  = data.github_repository.repo.node_id
  pattern        = "main"
  enforce_admins = false
  required_pull_request_reviews {
    require_code_owner_reviews      = true
  }
}

resource "github_branch_protection" "develop" {
  repository_id  = data.github_repository.repo.node_id
  pattern        = "develop"
  enforce_admins = false
  required_pull_request_reviews {
    required_approving_review_count = 2
  }
}

resource "github_repository_file" "codeowners" {
  repository          = data.github_repository.repo.name
  file                = ".github/CODEOWNERS"
  content             = "* @softservedata"
  branch              = "main"
  commit_message      = "Add CODEOWNERS file"
  overwrite_on_create = true
}

resource "github_repository_file" "pull_request_template" {
  repository          = data.github_repository.repo.name
  file                = ".github/pull_request_template.md"
  content             = <<EOT
Describe your changes

Issue ticket number and link

Checklist before requesting a review:
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
EOT
  branch              = "main"
  commit_message      = "Add pull request template"
  overwrite_on_create = true
}

resource "github_repository_deploy_key" "deploy_key" {
  repository = data.github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9Yl0rmHqRrVph5LU3rSAffj+EqHlNq6MD36X/gvMr/7r/e4J6Dzu7yJVhBHRyuOlZ9sFokT2yRXnp1+pmGyqk2mZHE3hpWeTraSRj3gfMqzVF184JVyy0g7QoNd5Pb42YW5ZMUnvHQ7Gcfb3Vhuf19EnpckOBzbiiNFJ0cYXWFNAJ9kzFthGtHqzNcACpNBguoXb6t0VPOZfPG/hYu+QI535XGfJ3KfcxpH0o/nXGof6C2It2kbS3H7sA1z9CoIEEbXg3WZR1+pOSCuGhJS4ROXgv/IafTO3TRjUARHQsGIKWGvk1rtuRf6aztLPWFKp2yqy2HAl+Ej5PAjK8Ti7y3FJuMlfCv39fucruz7C1igI+smc8kRbKqvkMUT3I3CeSgSIzFZdtgoGoAx4RizRcEOLWf7wOw2DfBrXPub90m3ywRuJ4kXragSinrXRHTAiGKG3uL/qNBO9lp5i6U5RV0djaJHR3e2nO2xmi1VNA7CnR2mEXyfOjHr56JSFX2i6yptiaUl7asrIS5H/msR3T8i1qU5QA3/jzhrbrStxdvO4WCrTiPGh8wI/APsj8lNQqOz7o/QgJKhYT1FCVFxVJMpZgw6guz2CVpzpUgOZSbeksxEf4FhQ9bWM5Fet3hwskVB7tprwfIDi2jWoa9W6gkbAbWTCcK1FlpjuZIMWnRQ== suprunS123@gmail.com"
  read_only  = false
}

resource "github_actions_secret" "PAT" {
  repository      = data.github_repository.repo.name
  secret_name     = "PAT"
  plaintext_value = "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"
}
