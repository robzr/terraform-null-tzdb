variable "enable_retrieve" {
  default     = false
  description = "Retrieve TZDB from web instead of using built-in, adds data lookup(s)."
}

variable "enable_self_update" {
  default     = false
  description = "Use with caution - for module maintenance, updates zone1970.tab with retrieved version."
}

variable "tzdb_url" {
  default     = "https://data.iana.org/time-zones/tzdb-%s/zone1970.tab"
  description = "URL referencing TZDB in zone1970 tab format (%s == -tzdb_version) (used with var.enable_retrieve)."
}

variable "tzdb_version" {
  default     = null
  description = "TZDB version, or set to null for latest version ((used with var.enable_retrieve)."
}

variable "tzdb_versions_url" {
  default     = "https://data.iana.org/time-zones/"
  description = "URL returning list of versions (used with var.enable_retrieve)."
}
