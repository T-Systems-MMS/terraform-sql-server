/**
 * # mssql
 *
 * This module manages Azure MS SQL.
 *
*/

resource "azurerm_mssql_server" "mssql_server" {
  for_each = var.mssql_server

  name                                 = local.mssql_server[each.key].name == "" ? each.key : local.mssql_server[each.key].name
  location                             = local.mssql_server[each.key].location
  resource_group_name                  = local.mssql_server[each.key].resource_group_name
  version                              = local.mssql_server[each.key].version
  administrator_login                  = local.mssql_server[each.key].administrator_login
  administrator_login_password         = local.mssql_server[each.key].administrator_login_password
  connection_policy                    = local.mssql_server[each.key].connection_policy
  minimum_tls_version                  = local.mssql_server[each.key].minimum_tls_version
  public_network_access_enabled        = local.mssql_server[each.key].public_network_access_enabled
  outbound_network_restriction_enabled = local.mssql_server[each.key].outbound_network_restriction_enabled
  primary_user_assigned_identity_id    = local.mssql_server[each.key].primary_user_assigned_identity_id

  dynamic "identity" {
    for_each = local.mssql_server[each.key].identity.type != "" ? [1] : []

    content {
      type         = local.mssql_server[each.key].identity.type
      identity_ids = local.mssql_server[each.key].identity.identity_ids
    }
  }


  dynamic "azuread_administrator" {
    for_each = local.mssql_server[each.key].azuread_administrator.login_username != "" ? [1] : []

    content {
      login_username              = local.mssql_server[each.key].azuread_administrator.login_username
      object_id                   = local.mssql_server[each.key].azuread_administrator.object_id
      tenant_id                   = local.mssql_server[each.key].azuread_administrator.tenant_id
      azuread_authentication_only = local.mssql_server[each.key].azuread_authentication_only.object_id
    }
  }

  tags = local.mssql_server[each.key].tags
}

resource "azurerm_mssql_database" "mssql_database" {
  for_each = var.mssql_database

  name                                = local.mssql_database[each.key].name == "" ? each.key : local.mssql_database[each.key].name
  server_id                           = local.mssql_database[each.key].server_id
  auto_pause_delay_in_minutes         = local.mssql_database[each.key].auto_pause_delay_in_minutes
  create_mode                         = local.mssql_database[each.key].create_mode
  creation_source_database_id         = local.mssql_database[each.key].creation_source_database_id
  collation                           = local.mssql_database[each.key].collation
  elastic_pool_id                     = local.mssql_database[each.key].elastic_pool_id
  geo_backup_enabled                  = local.mssql_database[each.key].geo_backup_enabled
  ledger_enabled                      = local.mssql_database[each.key].ledger_enabled
  license_type                        = local.mssql_database[each.key].license_type
  max_size_gb                         = local.mssql_database[each.key].max_size_gb
  min_capacity                        = local.mssql_database[each.key].min_capacity
  restore_point_in_time               = local.mssql_database[each.key].restore_point_in_time
  recover_database_id                 = local.mssql_database[each.key].recover_database_id
  restore_dropped_database_id         = local.mssql_database[each.key].restore_dropped_database_id
  read_replica_count                  = local.mssql_database[each.key].read_replica_count
  read_scale                          = local.mssql_database[each.key].read_scale
  sample_name                         = local.mssql_database[each.key].sample_name
  sku_name                            = local.mssql_database[each.key].sku_name
  storage_account_type                = local.mssql_database[each.key].storage_account_type
  transparent_data_encryption_enabled = local.mssql_database[each.key].transparent_data_encryption_enabled
  zone_redundant                      = local.mssql_database[each.key].zone_redundant

  dynamic "threat_detection_policy" {
    for_each = local.mssql_database[each.key].threat_detection_policy.state != "" ? [1] : []

    content {
      state                      = local.mssql_database[each.key].threat_detection_policy.state
      disabled_alerts            = local.mssql_database[each.key].threat_detection_policy.disabled_alerts
      email_account_admins       = local.mssql_database[each.key].threat_detection_policy.email_account_admins
      email_addresses            = local.mssql_database[each.key].threat_detection_policy.email_addresses
      retention_days             = local.mssql_database[each.key].threat_detection_policy.retention_days
      storage_account_access_key = local.mssql_database[each.key].threat_detection_policy.storage_account_access_key
      storage_endpoint           = local.mssql_database[each.key].threat_detection_policy.storage_endpoint
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = compact([
      local.mssql_database[each.key].long_term_retention_policy.weekly_retention,
      local.mssql_database[each.key].long_term_retention_policy.monthly_retention,
      local.mssql_database[each.key].long_term_retention_policy.yearly_retention,
      local.mssql_database[each.key].long_term_retention_policy.week_of_year
    ])

    content {
      weekly_retention  = local.mssql_database[each.key].long_term_retention_policy.weekly_retention
      monthly_retention = local.mssql_database[each.key].long_term_retention_policy.monthly_retention
      yearly_retention  = local.mssql_database[each.key].long_term_retention_policy.yearly_retention
      week_of_year      = local.mssql_database[each.key].long_term_retention_policy.week_of_year
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = compact([
      local.mssql_database[each.key].short_term_retention_policy.retention_days,
      local.mssql_database[each.key].short_term_retention_policy.backup_interval_in_hours
    ])

    content {
      retention_days           = local.mssql_database[each.key].short_term_retention_policy.retention_days
      backup_interval_in_hours = local.mssql_database[each.key].short_term_retention_policy.backup_interval_in_hours
    }
  }

  tags = local.mssql_server[each.key].tags
}

resource "azurerm_mssql_virtual_network_rule" "mssql_virtual_network_rule" {
  for_each = var.mssql_virtual_network_rule

  name                                 = local.mssql_virtual_network_rule[each.key].name == "" ? each.key : local.mssql_virtual_network_rule[each.key].name
  server_id                            = local.mssql_virtual_network_rule[each.key].server_id
  subnet_id                            = local.mssql_virtual_network_rule[each.key].subnet_id
  ignore_missing_vnet_service_endpoint = local.mssql_virtual_network_rule[each.key].ignore_missing_vnet_service_endpoint
}

resource "azurerm_mssql_firewall_rule" "mssql_firewall_rule" {
  for_each = var.mssql_firewall_rule

  name             = local.mssql_firewall_rule[each.key].name == "" ? each.key : local.mssql_firewall_rule[each.key].name
  server_id        = local.mssql_firewall_rule[each.key].server_id
  start_ip_address = local.mssql_firewall_rule[each.key].start_ip_address
  end_ip_address   = local.mssql_firewall_rule[each.key].end_ip_address
}
