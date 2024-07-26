check "tzdb_version_latest" {
  assert {
    condition = (
      local.enable_retrieve ?
      sort([
        local.tzdb_latest_available_version,
        local.tzdb_version,
      ])[0] == local.tzdb_latest_available_version :
      true
    )
    error_message = "Newer version of Time Zone Database is available."
  }
}

data "http" "iso3166" {
  count = local.enable_retrieve ? 1 : 0

  request_headers = {
    Accept = "application/text"
  }
  url = local.iso3166_url

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Error returned when retrieving ISO-3166 Database."
    }
  }
}

data "http" "tzdb" {
  count = local.enable_retrieve ? 1 : 0

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
      condition     = can(index(local.tzdb_available_versions, local.tzdb_version))
      error_message = "Variable tzdb_version is set to an invalid version."
    }
  }
}

data "http" "tzdb_versions" {
  count = local.enable_retrieve ? 1 : 0

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

resource "local_file" "iso3166" {
  count = var.enable_self_update ? 1 : 0

  content         = local.iso3166
  file_permission = "0644"
  filename        = local.iso3166_file
}

resource "local_file" "tzdb" {
  count = var.enable_self_update ? 1 : 0

  content         = local.tzdb
  file_permission = "0644"
  filename        = local.tzdb_file
}

resource "local_file" "tzdb_version" {
  count = var.enable_self_update ? 1 : 0

  content         = "${local.tzdb_version}\n"
  file_permission = "0644"
  filename        = local.tzdb_version_file
}

locals {
  enable_retrieve = var.enable_retrieve || var.enable_self_update
  iso3166         = local.enable_retrieve ? data.http.iso3166[0].response_body : file(local.iso3166_file)
  iso3166_file    = "${path.module}/iso3166.tab"
  iso3166_url = format(
    var.iso3166_url,
    local.tzdb_version,
  )
  tzdb = local.enable_retrieve ? data.http.tzdb[0].response_body : file(local.tzdb_file)
  tzdb_available_versions = (
    local.enable_retrieve ?
    regexall(
      "(?m)^<tr><td><a href=\"tzdb-(?P<version>[^\"]+)/\"",
      data.http.tzdb_versions[0].response_body,
    ).*.version :
    []
  )
  tzdb_file = "${path.module}/zone1970.tab"
  tzdb_latest_available_version = (
    length(local.tzdb_available_versions) > 0 ?
    local.tzdb_available_versions[length(local.tzdb_available_versions) - 1] :
    null
  )
  tzdb_url = format(
    var.tzdb_url,
    local.tzdb_version,
  )
  tzdb_version = (
    local.enable_retrieve ?
    coalesce(var.tzdb_version, local.tzdb_latest_available_version) :
    chomp(file(local.tzdb_version_file))
  )
  tzdb_version_file = "${local.tzdb_file}-version"
}
