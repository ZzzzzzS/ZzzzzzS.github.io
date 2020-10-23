---
title: 基于ZYNQ的HDMI视频输出接口设计
date: 2020-10-18 00:11:34
tags: [FPGA,HDMI]
mathjax: true
author:
 nick: ZZS
 link: https://zzzzzzs.github.io/
cover: https://zzshubimage-1253829354.file.myqcloud.com/fpga_hdmi/XILINX_LOGO.png
---

# 暂时没写完！！！

# 基于ZYNQ的HDMI视频输出接口设计

> 最近学习FPGA想做个具体的项目，正好开发板上也有一个HDMI接口，就打算写一个HDMI的控制器出来。目前实现的这个HDMI控制器只实现了部分HDMI协议，只支持普通视频传输功能，不支持传输音频，无法读取EDID信息等等问题。不过核心的图像传输功能实现了，那些不太重要的协议就以后有机会慢慢实现吧。

## 硬件介绍

在这里我使用的ALINX7020的开发板，开发板带有一个HDMI接口，芯片型号为**XC7Z020-2CLG400I**，其中HDMI相关的电路图如下所示：

![7644287362125475](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/media/image/7644287362125475.jpg)

除去供电和地，HDMI的信号线主要分了三类，分别是TMDS信号，

## HDMI协议介绍

## FPGA代码分析

## 填坑总结

## 参考文献




1）设立DE信号的意义

　　在输入到液晶显示器的视频信号中，有效视频信号（有效RGB信号）只占信号周期中的一部分，而信号的行消隐和场消隐期间并不包含有效的视频数据。因此，液晶显示器中的有关电路在处理视频信号时，必须将包含有效视频信号的区间和不包含有效视频信号的消隐区间区分开来。为了区分有效和无效视频信号，在液晶显示器电路中设置了DE信号。

　　（2）DE信号及其产生

　　图1所示为DE信号示意图，其中图（c）为DE信号。DE是一个高电平有效信号，在DE高电平期间所对应的视频数据信号被认为是有效数据信号，DE的高电平期间与CRT显示器中的扫描正程相对应。从图中可以看出，如果将消隐信号（见图（a））进行倒相，正好与DE信号相同，但因为在液晶显示器中不能处理三电平的同步／消隐信号，因此，单独设立了一个DE信号。
https://blog.csdn.net/weixin_30621959/article/details/95411364?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.add_param_isCf&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.add_param_isCf


HDMI同步参数问题？


https://blog.csdn.net/zhangningning1996/article/details/104458186 Xilinx中oserdes的原语及IP的使用