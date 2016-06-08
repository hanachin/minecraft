# EC2

IAMでAmazonEC2FullAccessをあげとく

## インスタンス起動

Amazon Linux選ぶ

> Amazon Linux AMI 2016.03.1 (HVM), SSD Volume Type - ami-29160d47


とりあえずt2.smallで

セキュリティグループは家からSSH出来るようにつくる。

削除保護の有効化は✔入れる。
ボリュームは合わせて削除の✔外す。

Name:minecraftでタグ付けしておく

## sshできたらやること

とりあえずアップデートしとく。

```
$ sudo yum update
```

~/.ssh/authorized_keysに自分の公開鍵を入れて自分の鍵でssh出来るようにする。

ssh minecraftでつなげるように~/.ssh/configを設定しておく

```
Host minecraft
  User ec2-user
  HostName ここにホスト
```

## serverkitでminecraftサーバーを整える

minecraftの起動スクリプトはwikiからとってきた。
http://minecraft.gamepedia.com/Tutorials/Server_startup_script/Script

```
$ ./provisioning.sh
```

## ポート開放

インバウンドTCP 25565を開けるマイクラ用セキュリティグループをつくってくっつける

## Elastic IPとRoute 53の設定

Elastic IPとってインスタンスにアタッチ。
minecraft.hanach.inをAレコードでElastic IPに向ける。
