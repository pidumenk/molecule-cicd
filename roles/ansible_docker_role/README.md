ansible_docker_role
=========

This role installs and configures Docker and dependencies on Ubuntu hosts.

Role Variables
--------------

The variables that is used in this role.

###### 
**docker_repo_url**: `deb https://download.docker.com/linux/ubuntu focal stable`

###### 
**docker_repo_key_url**: `https://download.docker.com/linux/ubuntu/gpg`

###### 
**docker_supplementary_packages_list**: 
  - `ca-certificates`
  - `curl`
  - `gnupg`

###### 
**docker_required_packages_list**: 
  - `docker-ce` 
  - `docker-ce-cli`
  - `containerd.io` 
  - `docker-buildx-plugin` 
  - `docker-compose-plugin` 

Examples
----------------

Configuration for ansible_docker_role:

	- hosts: os
	  roles:
	    - { role: ansible_docker_role, tags: docker }

Running playbook in the termial: 

```bash
ansible-playbook playbooks/os.yaml -t docker
```

License
-------

MIT

Author Information
------------------

Pavel Dumenko 

<pashadumenko35738@gmail.com>