provider "hcloud" {
  token = var.HCLOUD_TOKEN
}

resource "hcloud_network" "kubernetes" {
  name = "kubenet"
  ip_range = var.network_range
}

resource "hcloud_network_subnet" "kubernetes" {
  network_id = hcloud_network.kubernetes.id
  type = "server"
  network_zone = var.network_zone
  ip_range = var.network_subnet
}

resource "hcloud_floating_ip" "kubernetes" {
  type = "ipv4"
  home_location = var.location
  description = "Kubernetes Loadbalancer IP"
  name = "kubernetes-loadbalancer"
  labels = {
    "ingressip" = "true"
  }
}

resource "hcloud_ssh_key" "kubernetes_localfile" {
  count = var.ssh_rsa_key != "" ? 0 : 1
  name = var.ssh_key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_ssh_key" "kubernetes_fromvar" {
  count = var.ssh_rsa_key != "" ? 1 : 0
  name = var.ssh_key_name
  public_key = var.ssh_rsa_key
}
