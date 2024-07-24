variable "tzdb_url" {
  default     = "https://data.iana.org/time-zones/tzdb-%s/zone1970.tab"
  description = "URL referencing TZDB in zone1970 tab format (%s = -tzdb_version)."
}

variable "tzdb_version" {
  default     = null
  description = "TZDB version, or set to null for latest version."
}

variable "tzdb_versions_url" {
  default     = "https://data.iana.org/time-zones/"
  description = "URL returning list of versions; set to null to disable version checking."
}
