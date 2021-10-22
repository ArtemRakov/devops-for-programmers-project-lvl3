data "digitalocean_ssh_key" "ubuntu" {
  name = "do ubuntu"
}

data "digitalocean_domain" "default" {
  name = "rakov.me"
}

data "digitalocean_certificate" "cert" {
  name = "rakov.me-cert"
}

resource "digitalocean_record" "subdomain" {
  domain = data.digitalocean_domain.default.name
  type   = "A"
  name   = "@"
  value  = digitalocean_loadbalancer.app.ip
}

resource "digitalocean_droplet" "web" {
  count  = 2
  image  = "docker-20-04"
  name   = "web-${count.index + 1}"
  region = "fra1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
    data.digitalocean_ssh_key.ubuntu.id
  ]
}

resource "digitalocean_database_cluster" "db" {
  name       = "database"
  engine     = "pg"
  version    = "13"
  size       = "db-s-1vcpu-1gb"
  region     = "fra1"
  node_count = 1
}

resource "digitalocean_loadbalancer" "app" {
  name   = "loadbalancer"
  region = "fra1"

  dynamic "forwarding_rule" {
    for_each = [
      {
        port     = 80
        protocol = "http"
      },
      {
        port = 443
        protocol = "https"
      }
    ]

    content {
      entry_port = forwarding_rule.value["port"]
      entry_protocol = forwarding_rule.value["protocol"]

      target_port     = 80
      target_protocol = "http"

      certificate_name = data.digitalocean_certificate.cert.name
    }
  }

  healthcheck {
    port     = 80
    protocol = "http"
    path     = "/"
  }

  redirect_http_to_https = true
  droplet_ids = digitalocean_droplet.web.*.id
}

output "webservers" {
  value = digitalocean_droplet.web
}
