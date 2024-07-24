output "tzdb" {
  value = join(
    "\n",
    concat(
      [local.tzdb_comment],
      regexall(
        "(?m)^(?P<valid_line>[^#\t]+\t[^\t]+\t.*$)",
        data.http.tzdb.response_body,
      ).*.valid_line,
    )
  )
}

output "tzdb_version" {
  description = "Version of Time Zone Database."
  value       = local.tzdb_version
}
