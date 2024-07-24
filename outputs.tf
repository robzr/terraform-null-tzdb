output "tzdb" {
  description = "Map object of Time Zone Database, key is Time Zone name (ex: America/Los_Angeles)."
  value = merge([
    for tz in regexall(
      "(?m)^(?P<countrycodes>[^#\t]+)\t(?P<coordinates>[^\t]+)\t(?P<tz>[^\t\n]+)(?:\t(?P<comments>[^\n]*))?$",
      local.tzdb,
    ) :
    {
      (tz.tz) = {
        comments      = tz.comments
        coordinates   = tz.coordinates
        country_codes = split(",", tz.countrycodes)
      }
    }
  ]...)
}

output "tzdb_version" {
  description = "Version of Time Zone Database used/retrieved."
  value       = local.tzdb_version
}
