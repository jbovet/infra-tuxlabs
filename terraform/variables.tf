variable "token" {
  description = "Your Linode API Access Token (required)"
}

variable "nodes_count" {
  description = "Worker nodes count(required)"
  default     = "3"
}

variable "k8s_version" {
  description = "The Kubernetes version to use for this cluster. (required)"
  default     = "1.22"
}

variable "label" {
  description = "The unique label to assign to this cluster. (required)"
  default     = "tuxlabs"
}

variable "region" {
  description = "The region where your cluster will be located. (required)"
  default     = "us-east"
}

variable "tags" {
  description = "Tags to apply to your cluster for organizational purposes. (optional)"
  type        = list(string)
  default     = ["tuxlabs", "labs", "k8s"]
}
variable "conn_throttle" {
  description = "Throttle connections per second (0-20). Set to 0 (default) to disable throttling (optional)"
  default     = "20"
}



variable "pools" {
  description = "The Node Pool specifications for the Kubernetes cluster. (required)"
  type = list(object({
    type  = string
    count = number
  }))
  default = [
    {
      type  = "g6-standard-1"
      count = 3
    }
  ]
}

variable "cloudflare_email" {
  description = "The email associated with the account. (required)"
  default     = "jose.bovet@gmail.com"
}

variable "cloudflare_api_key" {
  description = "The Cloudflare API key. (required)"
}

variable "cloudflare_zone_id" {
  description = "The DNS zone ID to add the record to. (required)"
}
