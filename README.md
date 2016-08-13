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
$ envchain --set aws-hanachin-minecraft-admin TF_VAR_my_home_ip TF_VAR_minecraft_snapshot_id TF_VAR_minecraft_admin_public_key TF_VAR_minecraft_admin_private_key_path
```

Finally, apply terraform to your environment.

```
$ envchain aws-hanachin-minecraft-admin terraform apply
```

DNS
---------

Run `envchain aws-hanachin-minecraft-admin terraform show` to confirm ElasticIP

Open Routes 53 console and create A record 'minecraft.hanach.in' to the ElasticIP.

provisioning
------------

Add the following to `~/.ssh/config`.

```
Host minecraft
  User ec2-user
  HostName minecraft.hanach.in
  IdentityFile YOUR_PRIVATE_KEY_PATH
```

Set variables.

```
$ cp .envrc.sample .envrc
$ vi .envrc
$ cp variables.yml.sample variables.yml
$ vi variables.yml
```

Then run `$ ./provisioning.sh`.


Twitter bot
-----------

Create your apps at https://apps.twitter.com/

```
$ envchain --set twitter-hanachin_mc-mc_bot TWITTER_ACCESS_TOKEN TWITTER_ACCESS_TOKEN_SECRET TWITTER_CONSUMER_KEY TWITTER_CONSUMER_SECRET RUBOTY_NAME X_API_KEY ENDPOINT_URL
$ envchain twitter-hanachin_mc-mc_bot bundle exec ruboty
```

### deploy

```
$ envchain twitter-hanachin_mc-mc_bot ./provisioning_mc_bot.sh
```
