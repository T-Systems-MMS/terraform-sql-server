variable "mssql_server" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "mssql_database" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "mssql_firewall_rule" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "mssql_virtual_network_rule" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    mssql_server = {
      name                                 = ""
      administrator_login                  = null
      administrator_login_password         = null
      connection_policy                    = "Default"
      minimum_tls_version                  = "1.2"
      public_network_access_enabled        = true
      outbound_network_restriction_enabled = false
      primary_user_assigned_identity_id    = null
      azuread_administrator                = {}
      identity = {
        type         = ""
        identity_ids = null
      }
      azuread_administrator = {
        login_username              = ""
        tenant_id                   = null
        azuread_authentication_only = null
      }
      tags = {}
    }
    mssql_database = {
      name                                = ""
      auto_pause_delay_in_minutes         = null
      create_mode                         = "Default"
      creation_source_database_id         = null
      collation                           = null
      elastic_pool_id                     = null
      geo_backup_enabled                  = null
      ledger_enabled                      = false
      license_type                        = null
      max_size_gb                         = null
      min_capacity                        = null
      restore_point_in_time               = null
      recover_database_id                 = null
      restore_dropped_database_id         = null
      read_replica_count                  = null
      read_scale                          = null
      sample_name                         = null
      sku_name                            = null
      storage_account_type                = null
      transparent_data_encryption_enabled = true
      zone_redundant                      = null
      long_term_retention_policy = {
        weekly_retention  = null
        monthly_retention = null
        yearly_retention  = null
        week_of_year      = null
      }
      short_term_retention_policy = {
        retention_days           = null
        backup_interval_in_hours = null
      }
      threat_detection_policy = {
        state                      = ""
        disabled_alerts            = null
        email_account_admins       = null
        email_addresses            = null
        retention_days             = null
        storage_account_access_key = null
        storage_endpoint           = null
      }
      tags = {}
    }
    mssql_virtual_network_rule = {
      name                                 = ""
      ignore_missing_vnet_service_endpoint = false
    }
    mssql_firewall_rule = {
      name = ""
    }
  }

  # compare and merge custom and default values
  mssql_server_values = {
    for mssql_server in keys(var.mssql_server) :
    mssql_server => merge(local.default.mssql_server, var.mssql_server[mssql_server])
  }
  mssql_database_values = {
    for mssql_database in keys(var.mssql_database) :
    mssql_database => merge(local.default.mssql_database, var.mssql_database[mssql_database])
  }
  # merge all custom and default values
  mssql_server = {
    for mssql_server in keys(var.mssql_server) :
    mssql_server => merge(
      local.mssql_server_values[mssql_server],
      {
        for config in ["identity", "azuread_administrator"] :
        config => merge(local.default.mssql_server[config], local.mssql_server_values[mssql_server][config])
      }
    )
  }
  mssql_database = {
    for mssql_database in keys(var.mssql_database) :
    mssql_database => merge(
      local.mssql_database_values[mssql_database],
      {
        for config in ["threat_detection_policy", "long_term_retention_policy", "short_term_retention_policy"] :
        config => merge(local.default.mssql_database[config], local.mssql_database_values[mssql_database][config])
      }
    )
  }
  mssql_virtual_network_rule = {
    for mssql_virtual_network_rule in keys(var.mssql_virtual_network_rule) :
    mssql_virtual_network_rule => merge(local.default.mssql_virtual_network_rule, var.mssql_virtual_network_rule[mssql_virtual_network_rule])
  }
  mssql_firewall_rule = {
    for mssql_firewall_rule in keys(var.mssql_firewall_rule) :
    mssql_firewall_rule => merge(local.default.mssql_firewall_rule, var.mssql_firewall_rule[mssql_firewall_rule])
  }
}
