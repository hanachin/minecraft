Minecraft 🌏
============

My minecraft server.

build server
------------

```
$ brew install terraform envchain
````

Setup credentials.

```
$ envchain --set aws-hanachin-minecraft-admin AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION
```

Then create a bucket to store *.tfstate

```
$ envchain aws-hanachin-minecraft-admin terraform apply -target=aws_s3_bucket.minecraft_admin
```

Then store state files minecraft.tfstate and minecraft.tfstate.backup to the created S3 bucket.

```
$ envchain aws-hanachin-minecraft-admin terraform remote config -backend=S3 -backend-config="bucket=hanachin-minecraft-admin" -backend-config="encrypt=true" -backend-config="key=minecraft.tfstate"
```

Configure variables.

```
$ envchain --set aws-hanachin-minecraft-admin TF_VAR_my_home_ip TF_VAR_minecraft_snapshot_id TF_VAR_minecraft_admin_public_key
```

Finally, apply terraform to your environment.

```
$ envchain aws-hanachin-minecraft-admin terraform apply
```
