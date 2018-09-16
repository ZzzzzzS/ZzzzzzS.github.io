---
title: STM32培训
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
date: 2017-10-30 23:41:34
tags: [ARM,STM32,718创新实验室]
cover: https://zzshubimage-1253829354.file.myqcloud.com/STM32%E5%9F%B9%E8%AE%AD/0060lm7Tly1fkyepbkoosj30u01hc7bx.jpg
---
 
# STM32从入门到精通

>Hi~ 哈工大威海718联创培训营的小伙伴们你们好,这是我们进行**stm32**单片机培训的相关资料,包括完整的**示例程序,帮助文档,课件,** 以及单片机的 **硬件资料,原理图** 等等.我们还将在大家学习的过程中不断地更新资料.


# 版本更新说明
***

* 2017年10月15日 更新例程下载选项,以后无需手动选择下载器为STLink
* 2017年10月21日 修正了一个可能导致编译失败的问题,出现"core_cm3.o No such file"的小伙伴们可以更新试试
* 2017年10月22日 修正了SYSTICK定时器延时不正确的问题



# 资料下载
***
 * 下载地址:[**https://codeload.github.com/ZzzzzzS/STM32Learing/zip/master**](https://github.com/ZzzzzzS/STM32Learning/releases)
 * 备用下载地址:[**https://github.com/ZzzzzzS/STM32Learing**](https://github.com/ZzzzzzS/STM32Learing)
    >一般来说直接下载即可,若下载失败可点击备用下载地址,手动选择下载zip包,如图所示  ![下载失败](https://zzshubimage-1253829354.file.myqcloud.com/STM32%E5%9F%B9%E8%AE%AD/c5Iw4.png)

# 资料说明
***

|文件夹名|说明|
|------|----|
|原理图|硬件资料,说明电路连接情况|
|例程|各个外设示例程序|
|课程资料|上课ppt等资料|
|开始前的准备|软件安装等资料|
|帮助文档|由718创新实验室编写的例程和外设说明|
|ST官方资料|由ST意法半导体提供的相关说明|

>其他文件与stm32学习无关,有兴趣可自行研究




# stm32开发板简介
***
 ![单片机图片](https://zzshubimage-1253829354.file.myqcloud.com/STM32%E5%9F%B9%E8%AE%AD/c5hOU.png)



由718创新实验室设计制作的**stm32f103vet6**开发板采用ST意法半导体生产的基于ARM cortex-M3内核的 stm32f103vet6作为主控芯片,另外附加有陀螺仪,加速度传感器,键盘,数码管等多种常用外设.
### 以下是外设列表

 |名称&型号|作用|备注|
 |----|----|---------|
 |stm32f103vet6|主控芯片|
 |温度传感器|较精确采集温度|集成在mpu6050内部|
 |加速度传感器|感应加速度|集成在mpu6050内部|
 |陀螺仪|感应旋转角速度|集成在mpu6050内部|
 |单色LED灯||6个|
 |全彩LED灯||1个|
 |光电数码管|可以显示数字或其他信息|最多支持八位显示|
 |蜂鸣器|产生声音信号||
 |光敏电阻|感应光照强度||
 |热敏电阻|粗略感知环境温度||
 |独立按键|普通按钮|2个|
 |矩阵键盘|利用特殊的编码方式实现的普通按钮|共16个按键|
 |RTC晶振|可用于制作电子钟|
  
# 例程说明
***

 >这是建议的例程研究顺序
 
 * 空白工程:方便大家建立工程使用
 * 点亮一个小灯
 * 闪烁一个小灯
 * [流水灯闪烁](https://v.youku.com/v_show/id_XNDQxNTIxMzI=.html)
 * 独立按键操作
 * 矩阵键盘操作
 * [数码管](https://baike.baidu.com/item/%E6%95%B0%E7%A0%81%E7%AE%A1/9903965?fr=aladdin)显示(静态)
 * [数码管](https://baike.baidu.com/item/%E6%95%B0%E7%A0%81%E7%AE%A1/9903965?fr=aladdin)显示(动态)
 * TIM定时器中断
 * TIM定时器[PWM](https://baike.baidu.com/item/PWM%E4%BF%A1%E5%8F%B7/10621898?fr=aladdin)波
 * TIM定时器脉冲计数
 * USART[串口](https://blog.csdn.net/huwei2003/article/details/36418471)发送接收(查询)
 * USART[串口](https://blog.csdn.net/huwei2003/article/details/36418471)发送接收(中断)
 * I2C[陀螺仪](https://baike.baidu.com/item/%E9%99%80%E8%9E%BA%E4%BB%AA/84317?fr=aladdin)读写(模拟)
 * SPI [OLED](https://baike.baidu.com/item/OLED/1328114?fr=aladdin)显示
 * [ADC](https://baike.baidu.com/item/ADC/6529867)模拟量转数字量采集
 * [RTC](https://www.eepw.com.cn/article/273706.htm)实时时钟计时

***

#### POWERED BY **718** INNOVATION LAB

 
![logo](https://zzshubimage-1253829354.file.myqcloud.com/STM32%E5%9F%B9%E8%AE%AD/c55mF.png)

***
 
 

 


