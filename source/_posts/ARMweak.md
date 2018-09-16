---
title: ARM weak指令巧用
tags: [ARM,STM32]
author:
  nick: ZZS
  link: 'https://zzzzzzs.github.io/'
cover: 
categories: []
date: 2017-11-28 23:38:00
---

# 利用weak指令实现只声明不定义函数直接调用不出错

> 近来为新生编写一个蓝牙助手的下位机,采用了类似于面向事件的编程方法吧,蓝牙消息来了就会触发事件函数,把那些复杂的判断都封装起来了,也是方便使用吧.</br>但是有一个问题,事件函数是他们自己写,自己定义,我只是预先声明了,也调用了,但是没有定义.这样很明显是编译过不了的,而C语言又没有类似于C++虚函数一样的东西.利用ARM有的编译指令weak可以实现这个功能.

我的想法是如果使用者没有自己写事件函数,那么就执行我的报错函数,用串口输出报错信息,如果他们写了事件函数,那么就执行他们的事件函数.

而weak指令的定义为: **__weak函数用于定义变量或者函数，常见于定义函数，在MDK ARM链接时优先链接定义为非weak的函数或变量，如果找不到则再链接weak函数。** 正好符合我的要求.

以下是代码: 

这是报错函数

``` c
__weak void function1ButtonClickedEvent()
{
	
	printf("function1ButtonClicked\n");
	printf("if you see this, it means you DO NOT add your own function\n");
	printf("for more information,please look at https:///blog.zzshub.cn//\n");
}

```
这是用户需要写的函数

``` c
void function1ButtonClickedEvent()
{
  printf("test");
}
```

这是函数的调用(部分)
``` c
if(serialPortQueueBuffer[i+1]=='1')
			{
				function1ButtonClickedEvent();
			}
			else if(serialPortQueueBuffer[i+1]=='2')
			{
				function2ButtonClickedEvent();
			}
			else if(serialPortQueueBuffer[i+1]=='3')
			{
				function3ButtonClickedEvent();
			}
			else if(serialPortQueueBuffer[i+1]=='4')
			{
				function4ButtonClickedEvent();
			}
			else if(serialPortQueueBuffer[i+1]=='S')
			{
				stopButtonClickedEvent();
      }
```

***
EOF