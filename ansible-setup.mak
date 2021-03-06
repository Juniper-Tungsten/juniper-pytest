#!make
# <*******************
#
# Copyright 2019 Juniper Networks, Inc. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#    http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or otherwise agreed to in writing by the parties, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# *******************>

# Ansible Galaxy Juniper Junos roles version
ANSIBLE_JUNIPER_JUNOS := 2.1.0

# Path into which to install roles
ANSIBLE_ROLES_PATH ?= $(HOME)/.ansible/roles

# Install any required Ansible roles (into $HOME/.ansible/roles)
# Then set up symlinks for plugins to make sure they can be found.
.PHONY: ansible-roles
ansible-roles:
	ansible-galaxy install --roles-path=$(ANSIBLE_ROLES_PATH) Juniper.junos,$(ANSIBLE_JUNIPER_JUNOS)
