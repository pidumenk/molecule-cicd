ansible_jenkins_role
=========

This role installs and configures Jenkins and dependencies on Ubuntu hosts.

Role Variables
--------------

The variables that is used in this role.

###### 
**jenkins_repo_url**: `deb https://pkg.jenkins.io/debian-stable binary/`

###### 
**jenkins_repo_key_url**: `https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key`

###### 
**jenkins_required_packages_list**: 
  - `openjdk-11-jre`
  - `jenkins`
  - `git` 

Examples
----------------

Configuration for ansible_jenkins_role:

	- hosts: os
	  roles:
	    - { role: ansible_jenkins_role, tags: jenkins }

Running playbook in the termial: 

```bash
ansible-playbook playbooks/os.yaml -t jenkins
```

License
-------

MIT

Author Information
------------------

Pavel Dumenko 

<pashadumenko35738@gmail.com>