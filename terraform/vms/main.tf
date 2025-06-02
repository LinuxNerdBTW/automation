terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "1.2.0"
    }
  }
}

data "nutanix_cluster" "cluster" {
  name = var.cluster_name
}
data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}

provider "nutanix" {
  username     = var.user
  password     = var.password
  endpoint     = var.endpoint
  insecure     = true
  wait_timeout = 60
}


data "nutanix_image" "rocky" {
  image_name = "Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
}

data "local_file" "cloudinit" {
  filename = "${path.module}/cloud-init.yaml"
}

resource "nutanix_virtual_machine" "vms" {
  for_each = { for vm in var.vm_list : vm.name => vm }

  name                                     = each.value.name
  cluster_uuid                             = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket                     = each.value.vcpu
  num_sockets                              = 1
  memory_size_mib                          = each.value.memory
  guest_customization_cloud_init_user_data = filebase64(data.local_file.cloudinit.filename)

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.rocky.id
    }
  }

  disk_list {
    disk_size_bytes = 80 * 1024 * 1024 * 1024
    device_properties {
      device_type = "DISK"
      disk_address = {
        adapter_type = "SCSI"
        device_index = "1"
      }
    }
  }

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }
}


