---
title: 翻译 BLE低功耗蓝牙协议简介
date: 2018-05-19 14:12:32
tags: [Qt,BLE,蓝牙]
author: 
 nick: ZZS
 link: http://zzzzzzs.github.io/
cover: http://zzshubimage-1253829354.cosbj.myqcloud.com/BLE/09fa513d269759ee5be897d8b9fb43166d22df6d.jpg
---

> ### 原文连接 http://doc.qt.io/qt-5/qtbluetooth-le-overview.html

# BLE低功耗蓝牙简介
## 什么是低功耗蓝牙
低功耗蓝牙又被称为智能蓝牙(Bluetooth Smart),是一个于2011年提出的无线网络技术.与经典蓝牙("classic"Bluetooth)一样工作在2.4GHz.它的主要特点正如其名字一样,低能量消耗.它提供了一种仅仅用一颗纽扣电池就工作几月甚至几年的可能性.该项技术作为蓝牙4.0技术的子协议被叫做Bluetooth Smart Ready Devices.它的主要技术特点如下:
* 极低峰值,平均值功耗
* 可以使用纽扣电池驱动数年时间
* 低功耗
* 多网络互联
* 距离增强

低功耗蓝牙使用了一种客户端-服务端(client-server)结构.服务端(外围设备)提供服务,例如温度,心率等,并广播它们.客户端(中心设备)连接到服务端并读取被广播的数据.

## 基本服务结构
低功耗蓝牙BLE主要依靠两个协议:ATT(Attribute Protocol)以及GATT(Generic Attribute Protocol).它们是通信层中最重要的协议.

### ATT协议
基本的ATT协议主要包含三个元素:
* value - 一句被希望广播的信息
* UUID - 一种被GATT使用的属性
* 16bit的句柄 - 一个唯一的识别码

服务端储存这些属性,客户端利用ATT协议来读写这些属性

### GATT配置文件

GATT定义了不同的UUID编码来识别不同的服务,以下是一个例子:

![](https://zzshubimage-1253829354.file.myqcloud.com/BLE/%E8%8D%89%E5%9B%BE.png)
以上这些UUID由**Bluetooth Special Interest Group**官方定义,同样我们可以使用未被定义的UUID来实现我们的私有协议.总的来说,一个设备可以实现多个功能,由不同的UUID解释器来解释.