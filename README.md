# terraform-null-tzdb
Terraform module for querying Time Zone names and ISO-3166 Country Codes from
IANA Time Zone Database, with optional online database retrieval.

# Overview
The IANA (Internet Assigned Numbers Authority) maintains the authoritative 
[Time Zone Database](https://www.iana.org/time-zones) (TZDB). This module bundles
the latest version of the [zone9170.tab](./zone1970.tab) file, which correlates
Time Zone names (ex: America/Los\_Angeles) to associated ISO3166 country codes,
coordinates of the primary population center in the Time Zone, and any comments
of the Time Zone in context of the TZDB. The [iso3166.tab](./iso3166.tab) file
is also bundled, which is an IANA maintained map of ISO-3166 Country Codes to
their long form human-readable names.

# Usage
## Basic Usage
The top level module is used to return a Map representations of the ISO-3166
Country Code lookup table (`output.country_codes`) and a Map representation of
the latest version of the TZDB (`output.time_zones`) as of time of the module
publishing. By default, it uses the bundled files, which do not require any data
lookups or resources, so dependent resources deterministically be calculated
during a plan.

This is probably the syntax you want.
```hcl
module "tzdb" {
  source  = "robzr/tzdb/null"
  version = "~> 1.0"
}

locals {
  example_cc_lookup = module.tzdb.country_codes["US"]
  #
  # local.example_cc_lookup = "United States"

  example_tz_lookup = module.tzdb.time_zones["America/Los_Angeles"]
  #
  # local.example_tz_lookup = {
  #   "comments" = "Pacific"
  #   "coordinates" = "+340308-1181434"
  #   "country_codes" = tolist([
  #     "US",
  #   ])
  # }
}
## Online Database Retrieval
```
If a specific older version, or the latest version of TZDB at runtime is
necessary, there is also functionality to dynamically retrieve the TZDB using an
http data lookup. Note that any resources whose existence depends on the output
of a data lookup introduces complications in planning; along with the latency
introduced with the data lookup on a largely static dataset, this is only
recommended when needed.
```hcl
module "tzdb" {
  source  = "robzr/tzdb/null"
  version = "~> 1.0"

  enable_retrieve = true
}
```

# TODO
- Add support for parsing and returning rules & zone/rule relationships? This
  would be complex, and probably not all that useful. Implementing actual
  time offset resolution is not really feasible in pure Terraform given the
  complexity of the rules - that should be implemented in a provider.
