# CROC Kubernetes

Kubernetes cluster installer based on Terraform to use with CROC cloud.

## Getting Started

These instructions will get you a copy of the project up and running on CROC cloud. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

To run this setup you will need

```bash
terraform 0.11
packer
ansible
```

### Installing

To start this project please get /c2rc.sh script from CROC cloud and source it.
After you will have it run

```bash
terraform init
terraform apply -var-file vars/dev.tfvars
```

And then to connect to your instances run

```bash
terraform output ssh > id_rsa
chmod 0600 id_rsa
ssh ec2_user@node_ip -i id_rsa
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Terraform](https://www.terraform.io/docs/index.html) - Infrastructure as Code tool to provision and manage any cloud infrastructure, or service
* [Packer](https://www.packer.io/docs/index.html) - To build machine images
* [Ansible](https://docs.ansible.com/ansible/latest/index.html) - To provision machine images

## Contributing

Please read [CONTRIBUTING.md](https://gitlab.southbridge.ru) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).

## Authors

* **Pavel Selivanov** - *Initial work* - [Southbridge](https://github.com/centosadmin)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
