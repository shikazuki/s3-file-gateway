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
# ipaddress is private ipv4 of the storage gateway instance. 
ec2-user $ curl "http://10.0.1.xxx/?activationRegion=ap-northeast-1&no_redirect"
ACTIVATION_KEY
local    $ aws ssm put-parameter --name /s3fg-instance/filegateway/activation_key --value ACTIVATION_KEY --overwrite
```

Create storage gateway
```shell
$ terraform apply
```

```shell
$ sudo mkdir /mnt/shared-bucket
$ sudo mount -t nfs -o nolock,hard 10.0.1.xxx:/s3fg-shared-bucket /mnt/shared-bucket
```
