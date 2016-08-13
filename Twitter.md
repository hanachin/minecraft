# Twitterで電源のオン/オフ

メンションするとマイクラを起動するようにしたい

## 設計

マイクラ用のTwitterユーザーを作成しIFTTTと連携する。
そのユーザー宛にメンションが来たらAPI Gatewayにマインクラフトサーバー起動用のリクエストを投げる。

IFTTTではリクエストヘッダーを設定することができない。
なので、API GatewayではAPIキー認証を外したエンドポイントを作成する。

APIキー認証の代わりに、IFTTTからリクエストを投げる際に事前に定めた共通鍵とTwitterユーザー名をBodyに含め、λでその情報を元に認証を行う。
λでは共通鍵が一致していてかつメンションをくれたTwitterユーザー名がホワイトリストに含まれる場合、マインクラフトサーバーを立ち上げる。


## 起動用のλ関数を作る

Twitterのユーザー名のホワイトリスト、共通鍵で認証してから起動するためのλ関数を作成する。
λ関数のポリシーはiam/role/policies/StartMinecraftServer.jsonを使う。
名前は<q>StartMinecraftServerByTwitterNewMention</q>を設定。
内容は<q>lambda/StartMinecraftServerByTwitterNewMention.js</q>を貼り付け、以下3行を設定する。

```
const INSTANCE_ID = $instanceID;
const TWITTER_USER_NAMES = [];
const TOKEN = $token;
```

## API Gatewayにリソースをつくる

IFTTTと連携する際には以前作ったリソースのようにAPIキーで認証したくない。なので新しく/minecraft-server/iftttリソースを作る。
POSTメソッドでLambda関数のStartMinecraftServerByTwitterNewMentionを設定する。
終わったらデプロイする。

## curlで確認

```console
% curl -X POST $ENDPOINT_URL/ifttt
"start minecraft-server instance: failed, token is invalid"
% my_token=先ほど設定したTOKEN
$ curl -X POST $ENDPOINT_URL/ifttt -d "{\"token\":\"$my_token\"}"
"start minecraft-server instance: failed, user_name undefined is not found"
$ curl -X POST $ENDPOINT_URL/ifttt -d "{\"token\":\"$my_token\",\"user_name\":\"先ほど設定したTWITTER_USER_NAMESの1つ\"}"
"start minecraft server instance: done"
```
