# 注入IPA
## 先决条件
1. brew需要安装unzip包
2. chmod +x ../tool/GenShineImpactStarter

## iOS设备支持

iOS 12.0+

支持自签与巨魔。

## 准备砸壳包
自行寻找。

## 自动注入

使用原神,启动！二进制即可:

```bash
../tool/GenShineImpactStarter packipa "ipa文件路径" ./CoreInject.dylib
```

最终在"ipa文件路径"处找到一个 "ipa文件路径"_inject.ipa 文件即为最终产物。

## 目前支持状态:
|模式|状态|说明|
|-|-|-|
|自签|支持|无法使用iCloud同步|
|巨魔|支持|暂未编译 但支持 可用iCloud同步 有需要自己到频道找|

|App|状态|说明|
|-|-|-|
|Infuse|支持 8.1.9 以及后续所有版本|自签无法使用iCloud同步 https://t.me/qiuchenlymac/738|

部分ipa提供了注入好的ipa包，下载即可安装。请访问：https://t.me/qiuchenlymac 查看更多细节。

## 开发者

QiuChenly

20250708 

美国东部时间下午16:18分于洛杉矶
