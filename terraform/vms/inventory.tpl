%{~ for name, ip in jsondecode(masters_json) ~}
# master: ${name} -> ${ip}
%{~ endfor ~}

all:
  children:
    k8s_masters:
      hosts:
%{ for name, ip in jsondecode(masters_json) ~}
        ${name}:
          ansible_host: ${ip}
%{ endfor ~}
    k8s_workers:
      hosts:
%{ for name, ip in jsondecode(workers_json) ~}
        ${name}:
          ansible_host: ${ip}
%{ endfor ~}
  vars:
    ansible_user: mangale
    ansible_ssh_private_key_file: ~/.ssh/id_ed25519
    ansible_become: yes
