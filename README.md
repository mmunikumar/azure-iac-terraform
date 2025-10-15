# azure-iac-terraform
Secure Azure infrastructure using Terraform with Private Networking & GitHub Actions CI/CD.

## What this repo contains
- Terraform modules for network, storage, keyvault, and app service
- GitHub Actions workflows for deploy, rollback (destroy), and an integration test pattern
- Resources created are hardened for private-only access using Private Endpoints, Private DNS zones, and NSGs.

## Quickstart
1. Replace unique names in `variables.tf` (web_app_name, storage_account_name, key_vault_name).
2. Create an Azure Service Principal and add the following GitHub Secrets to your repo:
   - ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
3. Push to `main` to trigger `.github/workflows/deploy.yml` OR run Terraform locally:
   ```bash
   terraform init
   terraform plan -out=tfplan
   terraform apply tfplan
   ```
4. For production state, create an Azure Storage Account (bootstrap) and configure `backend.tf`.

## Notes & caveats
- Some operations that call the data plane of services with public access disabled may fail from GitHub Actions (public runner). Use an Azure VM inside the VNet or azapi workarounds for such steps.
- App Service and Key Vault names must be globally unique.
