resource "google_compute_firewall" "default" {
 name    = "mediawiki-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["80" ,"443"]
 }

 source_ranges = ["0.0.0.0/0"]
 source_tags = ["web"]

}

// Define VM resource
resource "google_compute_instance" "vm_instance" {
    name         = "mediawiki-vm"
    machine_type = "f1-micro"
    zone         = "${var.zone}"

    boot_disk {
        initialize_params{
            image = "centos-cloud/centos-7"
        }
    }

    metadata = {
        ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
    }

    network_interface {
        network = "default"
        access_config {
        }
    }
}

// Expose IP of VM
output "ip" {
 value = "${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip}"
}
