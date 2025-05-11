variable "key_name" {
  type = string
  description = "Nom de la clé SSH"
}

variable "ENVIRONMENT_NAME" {
  type = string
  description = "Environnement (test ou prod)"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "Clé d'accès AWS"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "Clé secrète AWS"
  type        = string
  sensitive   = true
}