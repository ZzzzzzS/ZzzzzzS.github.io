---
title: openwrt简单玩一玩
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
date: 2017-11-28 13:31:50
tags: [mips,Linux,OpenWrt]
cover: https://zzshubimage-1253829354.file.myqcloud.com/openwrt%E8%AF%95%E7%8E%A9/timg.jpg
---

> 紧接着上一次试玩hiwifiOS系统,最后发现实在是不过瘾,限制太多,尤其是软件安装方面的限制,然后资料又少,受不了了,就还是刷成了正宗的OpenWrt系统.

# OpenWrt版本简介

刷OpenWrt之前先简单说明一下OpenWrt的版本问题吧.**OpenWrt**到目前为止已经有了很多个版本,目前最新的是**15.05 Chaos Calmer** 版本,也就是很多人口中说的CC版.另外,常见的还有**Barrier Breaker 14.07**也就是BB版,还有更古老一点的**Attitude Adjustment 12.09**也就是AA版,这些就是系统版本的区别,就跟windows7和Windows8这样的区别类似.另外,OpenWrt作为嵌入式操作系统,支持众多处理器,不同处理器架构也有不同版本.而为了在安装的时候就把常见的驱动安装进去,每个安装包都附带了驱动,所以导致不同的处理器有不同的版本.比如我这个就是使用的mt7620处理器的15.05 CC版本.而之前的hiwifiOS则是使用mt7620处理器的14.04BB版上修改而成的.</br>除此之外,还有很多论坛上常说的**openwrt PandoraBox**就是一个有人做出来的为中国用户优化过的版本,没用过那个,就不多说了.

> 关于hiwifi如何刷OpenWrt,这个网上资料已经很多了,就不多说了,可以看看这个资料 https://www.jianshu.com/p/196a43b79c24

# OpenWrt从外部设备启动

> 主要参考这篇博客 https://www.cnblogs.com/double-win/p/3841801.html

整个前面的操作和博客里面讲的一样,不过由于我这个版本里面已经集成了那些驱动,就没有再下载了
```
mkdir /tmp/root        　　　　　　 #在/tmp目录下创建一个临时目录，用于放置系统镜像
mount /dev/sda1 /mnt　　　　　　　　#将/dev/sda1 挂载到/mnt目录下
mount -o bind / /tmp/root　　　　　#将根目录"/"制作镜像，并将其挂载到“/tmp/root”下
cp /tmp/root/* /mnt -a　　　　　　　#将/tmp/root/ 目录下的所有内容复制到/mnt下，相当于将/mnt/root下的所有内容复制到/dev/sda1下
umount /tmp/root    　　　　　　　　#解除挂载 /tmp/root

```

到这一步开始就和博客上面说的不一样了.按照博客的说法,始终无法启动,或者好不容易勉强启动起来了,就到处出问题,网络驱动工作不正常等等.</br>
之后仔细研究了一下,发现按照之前的做法,我是直接将sd卡设置成为openwrt的根目录点,其实这样是错误的.OpenWrt采用了一种叫做**Overlay**透明挂载的技术.大概意思就是先把磁盘中的一个恢复分区挂载到根目录下,然后使用透明挂载技术将我们认为的根目录挂载到根目录的位置,再将之前的恢复分区挂载到/rom目录下,这样就是overlay透明挂载.这样做有很大的好处,按下出厂设置键之后就直接删掉当前的根目录,就会露出恢复分区的目录,这样就可以很容易的实现系统出厂设置.而恢复分区是使用的只读文件系统,无法更改,所以出厂设置也一定能够恢复回来.
>有关openwrt的挂载可以看看这个 https://www.leiphone.com/news/201406/diy-a-smart-router-topic-openwrt.html

了解到这个透明挂载技术之后思路就清楚了.之前的挂载少了透明挂载这一层,就出问题了.设置一下就好.好在luci也给我们提供了图形化的设置工具,不需要命令行.接下来看图!

![](
https://zzshubimage-1253829354.file.myqcloud.com/openwrt%E8%AF%95%E7%8E%A9/%E8%8D%89%E5%9B%BE.png )

选择到**系统->挂载点**这一栏就会看到这样的画面,可以看到此时overlay那一层是14.29GB,大约是sd卡的大小.**这就是设置成功的标志之一**

![](
https://zzshubimage-1253829354.file.myqcloud.com/openwrt%E8%AF%95%E7%8E%A9/%E8%8D%89%E5%9B%BE2.png)

选择下面的添加挂载点,就会进入上面的界面,之后添加sd卡的位置.**然后关键的一步**:**设置挂载点为外部overlay而不是根目录**保存后重启一下路由器.好了,就设置好了.

其实看上去很简单的一步,自己研究的过程却复杂,不过成功之后也有一点小小的激动.就是这样小激动和漫长钻研过程中不断学习吧


# OpenWrt控制串口
> 熟悉嵌入式方面的人都知道串口是一个非常重要的设备。所以我也是最先研究这个串口设备，只要串口通信设置好了，那么利用串口和其他微控制器通信，再加上OpenWrt的远程通信的能力，那么就可以做到远程控制一大票东西了。废话不多说，直接开始串口的调试！

## 焊接串口
上次的拆机发现hiwifi 1S中是留有串口的焊盘的，只不过没有焊接而已(说实话一直觉得hiwifi挺良心的)。卸下烦人的三角形螺丝，拔出主板，焊接串口线，上电，测试正常，完成！

![](https://zzshubimage-1253829354.file.myqcloud.com/openwrt%E8%AF%95%E7%8E%A9/04F747091AEF90654CD185EBF962CB9D.png )

可以看到，中间有四个焊接的排针。

## 串口配置
在linux上，一切都是文件，串口等外部设备也是一样的。读和写串口在linux上其实就是读和写一个文件。和读写普通文件唯一有点区别的就是需要配置一下串口的波特率。

第一步首先安装串口的驱动
``` 
opkg update  //更新软件列表
opkg install coreutils-stty //安装stty
```
安装完成之后设置波特率
```
stty -F /dev/ttyS0 raw speed 115200  //设置ttyS0串口的波特率为115200
```
其中，`/dev/ttyS0`就是串口设备的名字，这个可以在开机的时候查看启动的信息查看到。 </br>其实，这句话也可以不需要，因为串口开机默认是使用115200波特率的。

## 串口读写
其实串口读写非常简单，就是前面所说的文件的读写

#### 写串口：
```
echo "hello" > /dev/ttyS0  //向串口输出字符"hello"

```
#### 读串口：
```
 cat /dev/ttyS0  //读取串口 
 ```

 ## 利用C语言程序实现串口读写

对于读写文件来说，分为几个步骤：
* 打开文件
* 获取文件编号(感觉类似于文件指针)
* 读文件或者写文件

对于打开文件使用open函数
`int open( const char * pathname, int flags);`

读文件使用read函数

``` c
#include <unistd.h>    
ssize_t read(int fd, void *buf, size_t count);  
//返回值：成功返回读取的字节数，出错返回-1并设置errno，如果在调read之前已到达文件末尾，则这次read返回0
```
写文件使用write函数

``` c
#include <unistd>
ssize_t write(int filedes, void *buf, size_t nbytes);
// 返回：若成功则返回写入的字节数，若出错则返回-1
// filedes：文件描述符
// buf:待写入数据缓存区
// nbytes:要写入的字节数
```
#### 最后，以下是整个测试程序

``` c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

unsigned char receivebuff[20];

int main()
{
	int flag;
	int file=open("/dev/ttyS0",O_RDWR);
	if(file==-1)
	{
		printf("Open Failed");
		return 0;
	}
	while(1)
	{
		flag=0;
		flag=read(file,&receivebuff,1);
		if(flag!=0)
		{
			write(file,&receivebuff,flag);
		}
	}
}
```

![](
https://zzshubimage-1253829354.file.myqcloud.com/openwrt%E8%AF%95%E7%8E%A9/psb.png)

![](https://zzshubimage-1253829354.file.myqcloud.com/openwrt%E8%AF%95%E7%8E%A9/psb.png)
