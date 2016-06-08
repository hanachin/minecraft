# APIを作成する

## APIを作成するためのユーザーを作成

IAMでAWSLambdaFullAccess, AmazonAPIGatewayAdministratorを付与したグループ/ユーザーを作成

## 参考資料

以下を参考にすすめる

[Lambda 関数の同期呼び出しを行う - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/getting-started.html)

## API名

Minecraft Switch

## Lambdaのロール

lambda_basic_executionを作り、インラインポリシーでiam/role/policiesの内容でロールポリシーを作る。
iam/role/policiesの`$accountId`はサポートページの右上に表示されているアカウント番号を使う
https://console.aws.amazon.com/support/home?region=ap-northeast-1#/

## Lambdaの関数

サーバーの起動停止があればいいので2つ用意する。

lambda/StartMinecraftServer.jsとlambda/StopMinecraftServer.jsの`$instanceID`を適当に置き換えて使う。

## API Gatewayで起動する/終了するAPIつくる

api/Minecraft  Switch-production-swagger.yamlを使う

- POST /minecraft-serverでStartMinecraftServerを呼ぶ
- DELETE /minecraft-serverでStopMinecraftServerを呼ぶ

ように設定してステージにデプロイ

## つかいかた

.envrc.sampleで設定している環境変数を設定したあと、bin/mc-startでマイクラをはじめ、終わったらbin/mc-stopでとめる

```sh
export X_API_KEY=
export ENDPOINT_URL=
```
