resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-apim"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  subnet_id                 = azurerm_subnet.subnet-app.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "allow-inbound-infra-lb" {
  name                        = "allow-inbound-infra-lb"
  access                      = "Allow"
  priority                    = 1000 # between 100 and 4096, must be unique, The lower the priority number, the higher the priority of the rule.
  direction                   = "Inbound"
  protocol                    = "Tcp" # Tcp, Udp, Icmp, Esp, Ah or * (which matches all).
  source_address_prefix       = "AzureLoadBalancer" # CIDR or source IP range or * to match any IP, Supports Tags like VirtualNetwork, AzureLoadBalancer and Internet.
  source_port_range           = "*" # between 0 and 65535 or * to match any
  destination_address_prefix  = "VirtualNetwork"
  destination_port_range      = "6390"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allow-inbound-apim-vnet" {
  name                        = "allow-inbound-apim-vnet"
  access                      = "Allow"
  priority                    = 1001 # between 100 and 4096, must be unique, The lower the priority number, the higher the priority of the rule.
  direction                   = "Inbound"
  protocol                    = "Tcp" # Tcp, Udp, Icmp, Esp, Ah or * (which matches all).
  source_address_prefix       = "ApiManagement" # CIDR or source IP range or * to match any IP, Supports Tags like VirtualNetwork, AzureLoadBalancer and Internet.
  source_port_range           = "*" # between 0 and 65535 or * to match any
  destination_address_prefix  = "VirtualNetwork"
  destination_port_range      = "3443"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}