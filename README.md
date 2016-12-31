# hey_raspi
音声操作BOT  
Siriのようなもの  
音声で命令すると実行してくれる

# Ruby
2.3.0

# Tools
OpenWeatherMap API  
Julius

# COMMANDS
現在実装されている命令
- ヘイラズパイ  
命令受け付けモードにする（この命令の後に以下の命令を言う）
- 今日の天気は？  
現在時刻以降の天気の情報（雨が降るか否か）を教えてくれる
- 明日の天気は？  
明日の天気の情報（雨が降るか否か）を教えてくれる

# HOW TO
サンプルをもとに`.secret.yaml`を作成．  
`CITY_ID`は[こちら](http://bulk.openweathermap.org/sample/city.list.json.gz)のjsonファイル(約4MB)で確認．  
```
$ bundle install
$ sh ./julius-server.sh &   # 別のターミナルで実行でも可
$ ruby main.rb
```

## 動作確認
(IN：ユーザの発言，OUT:システムの発言)  
IN 「ヘイラズパイ」  
OUT 「pon-pon」  
IN 「今日の天気は？」(5秒以内に)  
OUT 「今日の天気は．．．」  
