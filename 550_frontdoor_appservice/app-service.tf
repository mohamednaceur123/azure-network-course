resource "azurerm_service_plan" "app_service_plan" {
  name                = "plan-app-service"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "app" {
  name                = "app-service-${var.prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  https_only = true

  site_config {
    application_stack {
      docker_image_name   = "jelledruyts/inspectorgadget" # "appsvc/staticsite:latest" "nginx:latest" # 
      docker_registry_url = "https://index.docker.io"     # https://mcr.microsoft.com
    }

    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
    # ip_restriction {
    #   service_tag               = "AzureFrontDoor.Backend"
    #   ip_address                = null
    #   virtual_network_subnet_id = null
    #   action                    = "Allow"
    #   priority                  = 100
    #   headers {
    #     x_azure_fdid      = [azurerm_cdn_frontdoor_profile.frontdoor.resource_guid]
    #     x_fd_health_probe = []
    #     x_forwarded_for   = []
    #     x_forwarded_host  = []
    #   }
    #   name = "Allow traffic from Front Door"
    # }
  }
}
