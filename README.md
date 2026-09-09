# Databricks schema Terraform module

One Unity Catalog schema.

Creates one schema inside an existing catalog and, when `grants` is not empty, one `databricks_grants` block on it.

## Resources

- `databricks_schema.this`
- `databricks_grants.this[0]` (count = 1 only when `grants` is not empty)

The resource addresses above are part of the DataTF import contract. Do not rename them.

## Usage

```hcl
module "schema" {
  source  = "536tech/schema/databricks"
  version = "1.0.0"

  catalog_name = "sales"
  name         = "bronze"
  comment      = "Raw landing"

  grants = [{
    principal  = "ingest@example.com"
    privileges = ["SELECT", "MODIFY"]
  }]
}
```

## Compatibility

Configure the Databricks provider in the calling root with a workspace endpoint.
This resource module is also used by the
[workspace pattern module](https://registry.terraform.io/modules/536tech/workspace/databricks/latest).
Each repository has its own releases. Consumers select an exact tested module version.

The resource addresses match the original workspace submodule in version 0.1.1.
To migrate a direct submodule call, change its source and version. Keep the module block name.
Run `terraform init` and require a plan with no resource changes.
DataTF exports continue to use the workspace pattern module and its existing import addresses.

## Development

Use Terraform 1.7 or later for the mock tests. The module supports Terraform 1.5 or later.

```sh
prek install
terraform init -backend=false -lockfile=readonly
terraform validate
terraform test
tflint --recursive
prek run --all-files
```

CI tests the committed provider version and the minimum supported provider, 1.128.0.
The workspace pattern module checks the complete DataTF contract and its integration behavior.

## License

[Apache-2.0](LICENSE).

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>= 1.5.0)

- databricks (>= 1.128.0, < 2.0.0)

## Providers

The following providers are used by this module:

- databricks (>= 1.128.0, < 2.0.0)

## Resources

The following resources are used by this module:

- [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) (resource)
- [databricks_schema.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema) (resource)

## Required Inputs

The following input variables are required:

### catalog\_name

Description: Name of the catalog that holds the schema.

Type: `string`

### name

Description: Schema name.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### comment

Description: Schema description.

Type: `string`

Default: `null`

### force\_destroy

Description: Allow Terraform to delete the schema while it still contains tables.

Type: `bool`

Default: `false`

### grants

Description: Direct schema grants. A list permits computed service principal application IDs.

Type:

```hcl
list(object({
    principal  = string
    privileges = list(string)
  }))
```

Default: `[]`

### storage\_root

Description: Managed storage location for the schema. Changing it replaces the schema.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### id

Description: Schema id, in the form `catalog.schema`.

### name

Description: Schema name.
<!-- END_TF_DOCS -->
