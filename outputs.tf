output "country_codes" {
  description = "Map object of ISO-3166 table, key is Country Code (ex: US), value is name."
  value = merge([
    for country in regexall(
      "(?m)^(?P<code>[^#\t]+)\t(?P<name>[^\n]*)$",
      local.iso3166,
    ) : { (country.code) = country.name }
  ]...)
}

output "time_zones" {
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
