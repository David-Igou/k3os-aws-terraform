# k3os-aws-terraform

This is a WIP, in its first MVP.

The purpose of this repo is to deploy k3os on AWS, and defining configuration via terraform variables. The current design is meant to be light weight with limited features, but very easy to bring up.

Currently this only supports a single master deployment.

Future pushes will add AWS plugins, db options, loadbalancer options, more k3s flags, and hopefully I'll find an easy way to automatically deploy manifests post install.

The arguments for cloudprovider plugin/EBS CSI plugin are currently hard coded, but the plugins themselves are untested. This will be made more dynamic

