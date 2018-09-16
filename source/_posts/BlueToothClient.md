---
title: 蓝牙接收端帮助文档
tags: [ARM,STM32,蓝牙,718创新实验室]
author:
  nick: ZZS
  link: 'https://zzzzzzs.github.io/'
cover: https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/%E8%93%9D%E7%89%99%E4%B8%8A%E4%BD%8D%E6%9C%BA/cyaHx.jpg
categories: []
date: 2017-11-28 23:48:00
---

# 新生杯智能车大赛蓝牙接收端帮助文档

***

# 写在前面

> 这个蓝牙接收端于蓝牙上位机配套使用,使用当蓝牙上位机发出指令后,接收程序能够分析上位机发送的信号,并且执行相关的函数

# 大体流程
串口接收数据->将数据加入数据缓冲区->在while中一直判断缓冲区中的数据->如果有相关的指令->执行相关数据处理函数

# 添加源文件
使用蓝牙接收端程序需要手动在工程中添加`SerialPortImformation.c` 和 `SerialPortImformation.h` 之后再`include "SerialPortImformation.h"`</br>另外,因为需要使用串口,所以也需要添加串口USART相关的头文件

# 关于 SerialPortImformation.h
``` c
typedef struct
{
	int GoSpeed;
	int GoSpeedOld;
	int TurnSpeed;
	int TurnSpeedOld;
	uint8_t OtherInfo;
	unsigned char serialPortQueueBuffer[BUFFERSIZE+5];
} serialPortInfo;
```
这个结构体用于判断上位机发送过来的数据,serialPortQueueBuffer是一个用来暂时储存发来的数据的数组

``` c
#define BUFFERSIZE 20
```
这个用来调节数据缓冲区的大小,一般不需要修改

``` c
void addSerialPortDate(unsigned char data,serialPortInfo *this)
```
将数据添加进缓冲区,第一个参数是需要添加的数据,第二个参数是需要添加到的结构体的地址

``` c
serialPortexec(serialPortInfo *serialPortInfo)
```
这个是判断信息的函数,参数是serialPortInfo结构体的地址


# 初始化
任何外设使用以前都需要初始化,串口也一样.所以使用之前一定要初始化串口,串口如何初始化我就不再赘述了,不熟悉的同学可以查看我们之前的例程和教程.或者看我新写的这个例程也可以.</br>另一部分就是这个判断串口指令的初始化,这个由于不是外设,只需要创建一个全局变量就好了

`serialPortInfo blueToothInfo;`

# 如何使用
以前已经讲过,串口接收到数据之后就会进入串口中断函数.我们这时只需要将串口接收到的数据传输给蓝牙判断的结构体中就好了,以下是串口中断的部分代码
``` c
void USART1_IRQHandler(void){
	uint8_t ucTemp;
	if(USART_GetITStatus(USARTx,USART_IT_RXNE)!=RESET)		
	{		
		ucTemp = USART_ReceiveData(USARTx);
		addSerialPortDate(ucTemp,&blueToothInfo);
	}	 
}
```

可以看到这一句`addSerialPortDate(ucTemp,&blueToothInfo);`就是将接收到的数据传输给蓝牙结构体的

使用的另一个部分就是判断接收到的数据,这个只需要使用`serialPortexec(serialPortInfo *serialPortInfo);`函数即可.由于需要一直判断,所以需要在while里面一直执行这个函数,以下是部分代码

``` c
while(1){
	serialPortexec(&blueToothInfo);
}
```
最后一个部分就是执行操作了,因为大家对上位机上不同的按键执行的操作不同,所以就需要大家自己编写函数了.比如想让功能键1被按下时执行的任务,那么只需要写一个函数名为`void function1ButtonClickedEvent()`,那么当功能键一被按下时就会执行这个函数里面的内容.同理,当上位机上面速度设定发生改变的时候就会执行`speedchangeEvent(int xSpeed,int ySpeed)`这个函数里面的内容.以下是一些函数

|事件|执行的函数|备注|
|---|---------|-----|
|功能键1被按下|function1ButtonClickedEvent(void)||
|功能键2被按下|function2ButtonClickedEvent(void)||
|功能键3被按下|function3ButtonClickedEvent(void)||
|功能键4被按下|function4ButtonClickedEvent(void)||
|停车键被按下|stopButtonClickedEvent(void)||
|设定速度发生改变|speedchangeEvent(int xSpeed,int ySpeed)|传进来的参数xSpeed和ySpeed就是改变之后的速度|

有兴趣想知道这个是怎么实现的可以看我的另一篇文章[ARMWeak指令](/2017/11/28/ARMweak/index.html)

# 重要说明
* 例程144行的函数`int fputc(int ch, FILE *f)`不要删去,否则printf函数将无法使用
* 关于"执行的函数"如果不写的话也没有关系,就会执行我默认的函数,不过这样就无法实现你们想要的功能了