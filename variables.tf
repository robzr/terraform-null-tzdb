variable "enable_retrieve" {
  default     = false
  description = "Retrieve TZDB from web instead of using built-in, adds data lookup(s)."
}

variable "enable_self_update" {
  default     = false
  description = "Use with caution - updates variables.tf with retrieved version of TZDB."
}

variable "tzdb" {
  default     = null
  description = "Contents of TZDB file, null retrieves from var.tzdb_file."
}

variable "tzdb_file" {
  default     = "${path.module}/zone1970.tab"
  description = "Path to TZDB file, used when var.enable_retrieve == false."
}

variable "tzdb_url" {
  default     = "https://data.iana.org/time-zones/tzdb-%s/zone1970.tab"
  description = "URL referencing TZDB in zone1970 tab format (%s == -tzdb_version)."
}

variable "tzdb_version" {
  default     = null
  description = "TZDB version, or set to null for latest version."
}

variable "tzdb_versions_url" {
  default     = "https://data.iana.org/time-zones/"
  description = "URL returning list of versions; set to null to disable version checking."
}
