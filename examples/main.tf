module "mssql" {
  source = "registry.terraform.io/T-Systems-MMS/mssql/azurerm"
  mssql_server = {
    service-db = {
      location                     = "westeurope"
      resource_group_name          = "service-rg"
      version                      = "12.0"
      administrator_login          = "mysqlroot"
      administrator_login_password = "password"
      tags = {
        service = "service_name"
      }
    }
  }
  mssql_database = {
    service = {
      server_id                        = module.mssql.mssql_server["service-db"].id
      max_size_bytes                   = "2147483648"
      edition                          = "Standard"
      requested_service_objective_name = "S0"
      tags                             = local.tags
    }
  }
  mssql_virtual_network_rule = {
    db-subnet = {
      resource_group_name = "service-rg"
      server_name         = module.mssql.mysql_server["service-db"].name
      subnet_id           = module.network.subnet.db-subnet.id
    }
  }
  mssql_firewall_rule = {
    proxy = {
      resource_group_name = "service-rg"
      server_name         = module.mysql.mysql_server["service-db"].name
      start_ip_address    = "127.0.0.1"
      end_ip_address      = "127.0.0.2"
    }
  }
}
