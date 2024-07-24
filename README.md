# terraform-null-tzdb
Terraform module for querying IANA Time Zone Database, with optional online
database retrieval.

# Overview
The IANA (Internet Assigned Numbers Authority) maintains the authoritative 
[Time Zone Database](https://www.iana.org/time-zones) (TZDB). This module bundles
the latest version of the [./zone9170.tab](zone1970.tab) file, which correlates
Time Zone names (ex: America/Los\_Angeles) to associated ISO3166 country codes,
coordinates of the primary population center in the Time Zone, and any comments
of the Time Zone in context of the TZDB.

# Usage
The top level module is used to return a Map representation of the latest version
of the TZDB as of time of the module publishing. By default, it uses the bundled
file, which does not require any data lookups or resources, so dependent
resources deterministically be calculated during a plan.
```hcl
module "tzdb" {
  source  = "robzr/tzdb/null"
  version = "~> 1.0"
}

locals {
  example_lookup = module.tzdb.tzdb["America/Los_Angeles"]

  # local.example_lookup = {
  #   "comments" = "Pacific"
  #   "coordinates" = "+340308-1181434"
  #   "country_codes" = tolist([
  #     "US",
  #   ])
  # }
}
```
If the latest (or a specific older) version of TZDB at runtime is necessary,
there is also functionality to dynamically retrieve the TZDB. Since data lookups
are used to retrieve it, resource decisions depending on interpreting the module
output may require multiple Terraform runs (this is common Terraform module
behavior). Only use this syntax if you need it.
```hcl
module "tzdb" {
  source  = "robzr/tzdb/null"
  version = "~> 1.0"

  enable_retrieve = true
}
```

# TODO
- Add dedicated or submodule for ISO3166 Country Code resolution
- Add support for rules? (would be complex; does anyone want this?)
