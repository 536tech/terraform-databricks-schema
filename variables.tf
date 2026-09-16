variable "catalog_name" {
  description = "Name of the catalog that holds the schema."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.catalog_name)) > 0, false)
    error_message = "catalog_name must not be empty or blank."
  }
}

variable "name" {
  description = "Schema name."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.name)) > 0, false)
    error_message = "name must not be empty or blank."
  }
}

variable "storage_root" {
  description = "Managed storage location for the schema. Changing it replaces the schema."
  type        = string
  default     = null
}

variable "comment" {
  description = "Schema description."
  type        = string
  default     = null
}

variable "grants" {
  description = "Direct schema grants. A list permits computed service principal application IDs."
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default  = []
  nullable = false

  validation {
    condition = try(alltrue([for grant in var.grants :
      length(trimspace(grant.principal)) > 0 && length(grant.privileges) > 0 &&
      alltrue([for privilege in grant.privileges : length(trimspace(privilege)) > 0])
    ]) && length(distinct([for grant in var.grants : grant.principal])) == length(var.grants), false)
    error_message = "Each grant needs a unique nonblank principal and at least one nonblank privilege."
  }
}

variable "force_destroy" {
  description = "Allow Terraform to delete the schema while it still contains tables."
  type        = bool
  default     = false
}
