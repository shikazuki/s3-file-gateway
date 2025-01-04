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

Create storage gateway server.
```shell
$ terraform apply -target=module.storage-gateway-instance
```

Get activation key in bastion server.
```shell
$ curl "http://10.0.1.xxx/?activationRegion=ap-northeast-1&no_redirect"
ACTIVATION_KEY
$ aws ssm put-parameter --name /s3fg-instance/filegateway/activation_key --value ACTIVATION_KEY --overwrite
```
