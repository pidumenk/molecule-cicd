ansible_molecule_role
=========

This role installs and configures Molecule and dependencies on Ubuntu hosts.

Role Variables
--------------

The variables that is used in this role.

###### 
**venv_folder**: `/opt/molecule-virtualenv`
###### 
**pip_required_packages_list**: 
  - `pytest`
  - `allure-pytest`
  - `pytest-testinfra`
  - `cryptography`
  - `molecule`
  - `molecule-plugins[molecule]`
  - `ansible`
  - `hvac`
###### 
**pip_upgrade_packages_list**: 
  - `pip`
  - `setuptools`
  - `wheel` 

Examples
----------------

Configuration for ansible_molecule_role:

	- hosts: os
	  roles:
	    - { role: ansible_molecule_role, tags: molecule }

Running playbook in the termial: 

```bash
ansible-playbook playbooks/os.yaml -t molecule
```

License
-------

MIT

Author Information
------------------

Pavel Dumenko 

<pashadumenko35738@gmail.com>