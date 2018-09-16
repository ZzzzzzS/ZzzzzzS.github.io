---
title: Shadowsocks使用方法
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
date: 2018-9-16 13:31:50
tags: [gfw,shadowsocks]
cover: https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/shadowsocks/Shadowsocks.png
---
# shadowsocks连接使用说明

> 本说明简单介绍shadowsocks的使用方法

# Windows平台

> 这个版本的客户端属于轻量级客户端,占用系统CPU资源少,基本可以让它一直运行,但是无法做到全局代理,也就是说无法代理游戏或者本身不支持代理的软件.需要全局代理的话往下看还有一个软件

## 软件下载

官方最新版: https://github.com/shadowsocks/shadowsocks-windows/releases

本站备用版本: [点击下载](https://zzsdownload-1253829354.file.myqcloud.com/Shadowsocks-4.0.10.zip)

## 安装说明

这个版本的客户端无需安装,双击即可运行.也可以配置成开启自动启动代理.被墙网站走代理,正常网站走正常流量的PAC模式.

## 配置说明

* 服务器地址填写 **shadowsocks.zzshub.cn**
* 服务器端口填写分配的端口
* 密码填写分配的密码
* 加密方式无特殊说明为**rc4-md5**
* 代理端口默认1080即可

### 配置成如图所示基本就好:

![](https://zzshubimage-1253829354.file.myqcloud.com/shadowsocks/%E8%8D%89%E5%9B%BE.png)

![](https://zzshubimage-1253829354.cosbj.myqcloud.com/shadowsocks/%E8%8D%89%E5%9B%BE2.png)

## 官方详细说明:

https://github.com/shadowsocks/shadowsocks-windows/wiki/Shadowsocks-Windows-%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E

## Windows平台网卡级代理

> 这个软件可以做到整个电脑上的所有流量全部走代理,但消耗CPU资源较多(全局模式10%以内,如果要选择只代理被墙的IP的话会消耗50%甚至更多的CPU资,建议开默认的全局模式就行).

## 软件下载

>这个软件的作者已经被喝茶,不再更新

本站地址: [点击下载](https://zzsdownload-1253829354.file.myqcloud.com/SSTap-beta-setup-1.0.6.exe.7z)

全部版本地址: https://github.com/ZzzzzzS/SSTap-beta-setup

## 配置过程


![](https://zzshubimage-1253829354.file.myqcloud.com/shadowsocks/%E8%8D%89%E5%9B%BE3.png)

整个配置过程都和上面差不多,需要注意的是类型需要选择成shadowsocks类型.

# 安卓平台

本站下载地址:[点击下载](https://zzsdownload-1253829354.file.myqcloud.com/com.github.shadowsocks.apk)

# IOS平台

App Store 搜索**Wingy,shadowsocks,ss**等关键词下载软件.因为苹果官方会不定期查封这些软件,所以软件的名字会一直变化.

# shadowsocks官方网站
>墙外的同学可以看一看

https://shadowsocks.org/en/index.html