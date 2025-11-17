# Ansible Role: Docker Swarm

Configure Docker Engine's "Swarm Mode" (https://docs.docker.com/engine/swarm/) to create a cluster of Docker nodes.
This is a minimal role that assumes Docker is already installed and configured on your hosts (e.g., Flatcar Linux).

## Requirements

See [test-requirements.txt](./test-requirements.txt).

## Dependencies

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    docker_swarm_interface: "{{ ansible_default_ipv4['interface'] }}"

Setting `docker_swarm_interface` allows you to define which network interface will be used for cluster inter-communication.

    docker_swarm_addr: "{{ hostvars[inventory_hostname]['ansible_' + docker_swarm_interface]['ipv4']['address'] }}"

Listen address for the Swarm raft API.
By default, the ip address of `docker_swarm_interface`.

    docker_swarm_port: 2377

Listen port for the Swarm raft API.

Swarm node labels
-----------------

[Node labels](https://docs.docker.com/engine/swarm/manage-nodes/#add-or-remove-label-metadata) provide a
flexible method of node organization. You can also use node labels in service constraints.
Apply constraints when you create a service to limit the nodes where the scheduler assigns tasks for the service.
You can define labels by `swarm_labels` variable, e.g:

    $ cat inventory
    ...
    [docker_swarm_manager]
    swarm-01 swarm_labels=deploy

    [docker_swarm_worker]
    swarm-02 swarm_labels='["libvirt", "docker", "foo", "bar"]'
    swarm-03
    ...

In this case:

    $ docker inspect --format '{{json .Spec.Labels}}'  swarm-02 | jq
    {
       "bar": "true",
       "docker": "true",
       "foo": "true",
       "libvirt": "true",
    }

You can assign labels to cluster running playbook with `--tags=swarm_labels`

**NB**: Please note, all labels that are not defined in inventory will be removed

## Example Playbook

    $ cat inventory
    swarm-01 ansible_ssh_host=172.10.10.1
    swarm-02 ansible_ssh_host=172.10.10.2
    swarm-03 ansible_ssh_host=172.10.10.3

    [docker_engine]
    swarm-01
    swarm-02
    swarm-03

    [docker_swarm_manager]
    swarm-01 swarm_labels=deploy

    [docker_swarm_worker]
    swarm-02 swarm_labels='["libvirt", "docker", "foo", "bar"]'
    swarm-03

    $ cat playbook.yml
    - name: "Provision Docker Swarm Cluster"
      hosts: all
      roles:
        - { role: atosatto.docker-swarm }

License
-------

MIT

Author Information
------------------

Andrea Tosatto ([@\_hilbert\_](https://twitter.com/_hilbert_))
[Planetary Quantum GmbH](https://github.com/hostwithquantum)
