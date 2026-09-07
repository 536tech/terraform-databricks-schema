mock_provider "databricks" {}

variables {

  catalog_name = "sales"
  name         = "bronze"
  comment      = "Raw landing"

  grants = [{
    principal  = "ingest@example.com"
    privileges = ["SELECT", "MODIFY"]
  }]
}

run "documented_example" {
  command = apply

  assert {
    condition     = databricks_schema.this.name == var.name
    error_message = "The resource must preserve its configured name."
  }

  assert {
    condition     = length(databricks_grants.this) == 1
    error_message = "Configured access must have stable resource addresses."
  }
}

run "without_access" {
  command = plan

  variables {
    grants = []
  }

  assert {
    condition     = length(databricks_grants.this) == 0
    error_message = "Empty access must omit the access resources."
  }
}
