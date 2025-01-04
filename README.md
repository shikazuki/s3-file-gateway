# s3-file-gateway

## Usage
```shell
$ terrform init
```

Create VPC definition first.
```shell
$ terraform apply -target=module.network
```

Create bastion server.
```shell
$ terraform apply -target=module.bastion_instance
```
