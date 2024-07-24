check "tzdb_version_latest" {
  assert {
    condition     = sort([local.tzdb_latest_available_version, local.tzdb_version])[0] == local.tzdb_latest_available_version
    error_message = "Newer version of Time Zone Database is available."
  }
}

data "http" "tzdb_versions" {
  request_headers = {
    Accept = "application/text"
  }
  url = var.tzdb_versions_url

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Error returned when retrieving list of Time Zone Database versions."
    }
  }
}

data "http" "tzdb" {
  request_headers = {
    Accept = "application/text"
  }
  url = local.tzdb_url

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Error returned when retrieving Time Zone Database."
    }

    precondition {
      condition = can(index(local.tzdb_available_versions, local.tzdb_version))
      error_message = "Variable tzdb_version is set to an invalid version."
    }
  }
}

locals {
  tzdb_available_versions = regexall(
    "(?m)^<tr><td><a href=\"tzdb-(?P<version>[^\"]+)/\"",
    data.http.tzdb_versions.response_body,
  ).*.version
  tzdb_comment = "# Retrieved from ${local.tzdb_url} with comments stripped by https://github.com/robzr/terraform-tzdb/retrieve"
  tzdb_latest_available_version = local.tzdb_available_versions[length(local.tzdb_available_versions) - 1]
  tzdb_url = format(
    var.tzdb_url,
    local.tzdb_version,
  )
  tzdb_version = coalesce(var.tzdb_version, local.tzdb_latest_available_version)
}
