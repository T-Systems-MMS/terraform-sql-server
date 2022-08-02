output "mssql_server" {
  description = "azurerm_mssql_server"
  value = {
    for mssql_server in keys(azurerm_mssql_server.mssql_server) :
    mssql_server => {
      id   = azurerm_mssql_server.mssql_server[mssql_server].id
      name = azurerm_mssql_server.mssql_server[mssql_server].name
    }
  }
}
output "mssql_database" {
  description = "azurerm_mssql_database"
  value = {
    for mssql_database in keys(azurerm_mssql_database.mssql_database) :
    mssql_database => {
      id   = azurerm_mssql_database.mssql_database[mssql_database].id
      name = azurerm_mssql_database.mssql_database[mssql_database].name
    }
  }
}
