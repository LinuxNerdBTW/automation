# Kubernetes Node Configuration with Ansible

This Ansible project configures the OS-level dependencies for Kubernetes master and worker nodes.

## Prerequisites

- Ansible installed on your control machine
- SSH access to all target nodes
- Target nodes running Ubuntu (tested on Ubuntu 20.04/22.04)

## Usage

1. Update the `inventory.yml` file with your actual node IPs and SSH credentials.

2. Run the playbook:
   \`\`\`bash
   ansible-playbook -i inventory.yml site.yml
   \`\`\`

3. To run only on specific node types:
   \`\`\`bash
   # For masters only
   ansible-playbook -i inventory.yml site.yml --limit k8s_masters
   
   # For workers only
   ansible-playbook -i inventory.yml site.yml --limit k8s_workers
   \`\`\`

## What This Configures

- Disables swap
- Loads required kernel modules (overlay, br_netfilter)
- Sets up required sysctl parameters
- Installs containerd with systemd cgroup driver
- Installs kubeadm, kubelet, and kubectl
- Configures hostname resolution between nodes

Note: This playbook does not initialize the Kubernetes cluster or join worker nodes. It only prepares the OS-level dependencies.
