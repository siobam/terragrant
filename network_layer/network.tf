terraform {
  # Live modules pin exact Terraform version; generic modules let consumers pin the version.
  # The latest version of Terragrunt (v0.29.0 and above) recommends Terraform 0.15.0 or above.
  required_version = "= 0.15.0"

  # Live modules pin exact provider version; generic modules let consumers pin the version.
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.25.0"
    }
  }
}
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-net-01"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "nsg_inbound_rules" {
  depends_on = [azurerm_network_security_group.nsg]
  count      = length(var.nsg_inbound_rules)

  name = var.nsg_inbound_rules[count.index]["name"]
  priority = lookup(
    var.nsg_inbound_rules[count.index],
    "priority",
    count.index == 0 ? 100 : count.index + 100,
  )
  direction         = lookup(var.nsg_inbound_rules[count.index], "direction", "Inbound")
  access            = lookup(var.nsg_inbound_rules[count.index], "access", "Allow")
  protocol          = var.nsg_inbound_rules[count.index]["protocol"]
  source_port_range = lookup(var.nsg_inbound_rules[count.index], "source_port_range", "*")
  destination_port_range = lookup(var.nsg_inbound_rules[count.index],"destination_port_range","*")
  source_address_prefix = lookup(var.nsg_inbound_rules[count.index], "source_address_prefix", "*")
  destination_address_prefix = lookup(var.nsg_inbound_rules[count.index],"destination_address_prefix", "*")
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.name
}
resource "azurerm_network_security_rule" "nsg_outbound_rules" {
  depends_on = [azurerm_network_security_group.nsg]
  count      = length(var.nsg_outbound_rules)

  name = var.nsg_outbound_rules[count.index]["name"]
  priority = lookup(
    var.nsg_outbound_rules[count.index],
    "priority",
    count.index == 0 ? 100 : count.index + 100,
  )
  direction         = lookup(var.nsg_outbound_rules[count.index], "direction", "Inbound")
  access            = lookup(var.nsg_outbound_rules[count.index], "access", "Allow")
  protocol          = var.nsg_outbound_rules[count.index]["protocol"]
  source_port_range = lookup(var.nsg_outbound_rules[count.index], "source_port_range", "*")
  destination_port_range = lookup(var.nsg_outbound_rules[count.index],"destination_port_range","*")
  source_address_prefix = lookup(var.nsg_outbound_rules[count.index], "source_address_prefix", "*")
  destination_address_prefix = lookup(var.nsg_outbound_rules[count.index],"destination_address_prefix", "*")
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.name
}
resource "azurerm_virtual_network" "network" {
  name                = "${var.prefix}-net-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["${var.address_space}"]
  dns_servers         = var.dns_servers

  subnet {
    name           = "front-end"
    address_prefix = var.front_end_address_prefix
    security_group = azurerm_network_security_group.nsg.id
  }

  subnet {
    name           = "back-end"
    address_prefix = var.back_end_address_prefix
    security_group = azurerm_network_security_group.nsg.id
  }
}