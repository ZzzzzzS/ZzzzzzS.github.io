---
title: hiwifi的正确打开方式
author: 
 nick: ZZS
 link: http://zzzzzzs.github.io/
date: 2017-11-21 23:41:34
tags: [mips,Linux,OpenWrt]
cover: 	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/cover.png
---

# hiwifi OS的正确打开方式

***

>近来频繁需要下载大文件,可是无奈,校园网速度感人.想着能不能把我的路由器改造成一个下载器来下载呢.于是,就开始了我的折腾之路</br>其实这个路由器高中就买了,当时作为家里的主力路由器,一直想折腾,不过也常常搞得网络不稳定,被家里人"投诉"了几次之后,也没有继续研究了.直到后来换了100M宽带,这个只有802.11n协议的路由器带不动了,退休下来,我才有机会仔细的研究一下

# hiwifi是什么
以下是[百度百科](https://baike.baidu.com/item/HiWiFi/8633008?fr=aladdin)的介绍:
>HiWiFi是北京极科极客科技有限公司推出的一款基于国外开源代码OpenWrt的无线路由系列，全称是“极路由 HiWiFi”，简称“小极”“HiWiFi”。

我手上的这块是hiWiFi 1S-HC5661,极路由官方的第二款产品.采用联发科的MT7620A处理器,这个处理器基于mips架构,560MHz主频,不过正是因为是mips架构的原因,应用程序非常少,交叉编译环境搭建也没那么顺利(相比Qt安卓的交叉编译环境还是要好弄很多).128M的ddr2内存,16M闪存,外置16GB SD卡.</br>软件方面,我目前使用的hiWiFi OS系统,不过看情况吧,可能以后还是要刷成原版OpenWrt.hiWiFi系统是一个基于OpenWrt深度定制而成的系统,而OpenWrt又是一个非常常见的嵌入式Linux系统,类似于小米的MiUI和安卓原生系统以及Linux之间的关系.


# 硬件+=USB  hiWiFi 1s拆机
不得不说,hiwifi 1s的外观设计的真是好看,全金属机身,阳极氧化工艺外壳.暗黑色的喷漆外壳上银色的化学侵蚀logo,配上亮色的倒切角工艺.与早些年间只是白色塑料外壳的路由器形成鲜明对比,简单的放在桌面上,也是不错的装饰品吧.另外,使用通用的5V2A-MicroUSB接口,也不用担心供电的问题.</br> 不过,这些都不是今天讨论的重点.其实很久以来就想拆开这个小家伙一探究竟了,只可以一直没有去到专用的三角螺丝刀,这个想法也一直搁置了下来.终于,忍不住了,没有专用螺丝刀,那就大力出奇迹吧.

![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/14193441483612.jpg )

一直都有所了解,hiwifi 1S是留有USB接口的,只不过没有印出来,拆开之后发现果不其然,只见USB焊盘,不见USB接口.另外,还发现了留有串口接口应该刷机变砖之后可以用这个刷回来,和没有焊接的802.11ac模块焊盘.不得不说,成品的电路板确实比自己设计的要成熟,各种滤波电容保护,还有各种拓展.</br>正题开始,改造USB!

![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/0e655ca7d933c8951f7a5601d21373f082020001.jpg)

通过观察PCB板上面的走线可以发现,USB的D+和D-其实是连接上了的,只不过USB的VCC和GND没有连接上,那么把电供上就可以使用了.短接如图红圈位置即可.什么?滤波电容?不存在的.根据我的猜测,红圈左边的6脚芯片应该是电源管理芯片,控制USB的供电,当然我也是不会添加的.哼,就不加,三极管都别想让我加.焊接好USB母口之后就是暴力的过程--在外壳上打一个洞,把USB口露出来.

![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/IMG_2096.JPG)

无奈手工不行,在机械专业的同学的远程指导下还是搞得这么丑.其实网上还有其他的不打洞,用线引出USB线的方法.有用百兆以太网剩下的4根线的,有用天线的缝隙的等等.不过我深知,线没过几天就会被我扯断,没有采用这个方法.

好,到这里,硬件改造就完成了,上电!工作正常,U盘挂载正常,连接正常.其实一路上也没有那么顺利,刚焊接好的时候路由器一上电就一直复位,把我吓坏了,以为又双叒叕短路了.重新焊接,无果,后来才发现是供电不足,没有使用5V2A的电源导致的.果断换电源,完成!




# 正式进入新世界--root&ssh
相信了解过Linux或者玩过安卓的人都知道root权限吧.hiWiFi上面获取root权限非常简单,去后台直接获取就好了.不过注意了,保修可就失去了,hiWiFi保修三年还是很良心的啦.</br>获取之后就配置ssh,注意官方给的端口号是1022,不过也有可能就是默认的22,这个时候官方已经默认帮你安装了ssh的server了,直接连接就好.Windows10 1709版本的话可以试试微软最新推出的Ubuntu On Windows(这玩意在后面会仔细讲一下),用这个连接ssh挺方便的,不然的话下载Putty也可以.
>在Ubuntu On Windows输入 ssh -p 1022 root@192.168.199.1

输入密码(就是后台管理密码)后出现以下界面就算是权限获取成功而且ssh服务已经打开了

 ![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE.png)
 
 哎,不愧是改的openwrt,连登陆界面都这么像.

 另外文件传输的话可以使用WinSCP,连接登录就好了,注意文件协议需要选择SCP.当然,也可以安装vsftp,用ftp传输文件也是可以的.

 ![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE2.png )



 # 个人网盘+远程下载器

 说到底,最开始研究这个路由器的初衷就是当个下载器用嘛.在以前,路由器上面有个迅雷的插件,可以利用迅雷的服务下载,无奈,迅雷关闭了这个服务.不过还好,Linux上不是还有个叫wget的命令行下载工具吗,利用它不就好了.直接cd到需要下载的目录下,wget+网址名就好了.不过等等,我的16G的SD卡呢? 执行命令 ` fdisk -l` 读取出SD卡了,只不过没有自动挂载 ` mount /dev/mmcblk0 /mnt`好的这下就把名称为mmcblk0的SD卡挂到根目录下的mnt文件夹上了,下载吧!不过很遗憾,路由器上的wget被阉割过了,支持的下载协议很少.凑合着下载吧,以后再找个好的.</br>不过停一下,我退出了ssh怎么下载就暂停了?再连接上,执行`top`,果然wget被杀进程了,保持后台下载,怎么办,linux上面有一个叫做`nohup`的命令,可是路由器上面没有啊.仔细寻找资料,发现只需要在命令的最后面加一个&就好了,非常方便,再次退出,果然下载还在继续.</br>
 下载之后怎么把东西移动到电脑上呢?一个很直接的办法,把SD卡拆下来插到电脑上就好了,不过放弃吧,文件系统不支持呢.路由器上使用的是ext4文件系统,这种文件无法被windows识别. 在局域网内部,可以采用smb协议传输文件,smb协议是微软推出的一种在局域网内部传输文件的协议,因为是在局域网内部,也不能加密传输.hiWiFi默认也是开启了smb服务的,在此电脑输入smb://192.168.199.1即可.好了,到目前为止,可以在局域网下访问的下载器就做好了.</br>
 文不对题啊,说好的远程呢?一步一步来,先看看学校的网络大环境,今年学校大修改,增加了1000M出口带宽(鼓掌!)之后,校网由以前的静态IP,客户端认证+MAC地址绑定变成了,动态IP+MAC地址绑定或者802.1x认证,同时无线校园网全校覆盖(衷心的感谢学校网络中心的努力,并同时希望网路中心能尽快修好实验室的网).这样看来,我只需要把路由器的MAC地址注册到我的名下,路由器就可以联网了.路由器设置成无线中继模式,连接到学校的wifi就好了.不过动态ip也带来了问题,我的ip一直在变啊,最开始以为变化的不是很快,然而我想错了,几乎半天就要变一次ip.看来有必要上ddns服务了,ddns服务是什么,首先了解dns服务,就是一个能够把域名解析成ip地址的玩意,那么ddns是什么,ddns可不是ddos,差一个字母,可完全不是一个东西,Dynamic DNS,动态dns,能够解析一直在变动的ip地址,也就是说我开启了ddns,不管IP地址怎么变化,我访问我的域名,总能获取到正确的ip地址.hiWiFi的ddns也是一个插件的事,利用不知道是谁提供的ddns服务(感谢那个不知道名字的陌生人,谢谢),分配给我了一个域名`zzscloud.jios.org.`什么玩意,这个域名好丑.免费的果然还是不靠谱,我可是由.cn的域名的男人,才不要你这玩意,做CNAME跳转吧.CNAME跳转就是由一个域名跳转到另一个域名的服务.以下是在腾讯云上做CNAME跳转

 ![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE3.png)

 好了,ip变化的问题就解决了,以为就可以远程访问了?错,看之前访问的192.x.x.x,这都是路由器的内网ip啊,可是远程只有路由器的公网ip,也就是学校分配的IP地址,这样做个端口映射即可,将学校的ip映射成内网的ip就可访问了.看这里:

 ![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE4.png)

 图形就是好,不过到后面就慢慢是命令了

 涉及到远程连接,不能加密的smb服务就不是那么安全了,换到更安全,更普遍使用的ftp服务势在必行.hiwifi上面安装ftp同样也非常简单,安装vsftpd插件即可.

 好了,这么一来,远程访问的问题终于弄好了,现在可以全校范围内访问路由器了.同学叫你分享文件,终于有了一种快(装)速(逼)的方式了哈哈.另外,远程ssh连接,远程管理路由器后台,甚至以后的远程挂摄像头,都需要这个作为基础.

 * http://hiwifi.zzshub.cn/
 * [ftp://hiwifi.zzshub.cn/](ftp://hiwifi.zzshub.cn/)

这是我的远程连接的地址,我怎么可能会把密码说出来呢.

 可是出校门了还能访问吗,因为学校分配的ip相对来说也是内网ip.实现全球能访问两个办法.1.让学校给我做端口映射,不可能.2.那就只好我自己做内网穿透咯.不过目前还没这方面的需要,以前做过效果也不是很好,留给以后去折腾吧.

 # 插件,插件,插件!

 hiwifi最初主打的功能就是智能路由器,能安装各种插件,比如番茄助手啥的.hiWiFi安装插件的方式可谓是简单的非常,复杂的也有点复杂.最简单的,直接去官方网页版插件市场安装就好了,不过插件数量很少限制也比较多,这部分跳过.</br>另一种安装方式当然就是用包管理器了.

 >[https://openwrt.io/docs/opkg/](https://openwrt.io/docs/opkg/) 这部分主要参考的这篇文档提供的内容

 hiwifiOS基于openwrt,而在openwrt上面有一个很好用的包管理器叫`opkg`类似于Ubuntu上面的`apt-get`

 |命令|作用|
 |---|----|
 |opkg install [软件名]|安装软件|
 |opkg update |更新软件源|
 |opkg list |查看可以安装的软件|
 |opkg list-installed|查看已安装的软件|
 |opkg remove [软件名]|卸载软件|

 另外还有`opkg -help`可以查看命令帮助,帮助写得比较详细了.

 用ssh连接 ``ssh -p 1022 root@hiwifi.zzshub.cn ``
 然后执行` opkg list`查看可以安装的软件.不过很遗憾,能够安装的很少.不科学啊,openwrt上软件可是很多的.全都怪hiwifi的软件源把插件都屏蔽掉了,那么我们换个openwrt的源不就好了.</br>查阅资料发现,opkg源文件存放在` /etc/opkg.conf`中,cd 到这个地方,打开vi编辑器`vi opkg.conf`如图所示添加几个源就好了
 
 ![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE45.png)

 顺便提一嘴,这个版本的vi真是好用,可以识别方向键和退格键等,不用频繁的进出编辑模式了,舒服.

 更新软件源`opkg update`再用`opkg list`发现可以安装的软件确实变多了好多.那么,慢慢下载这些插件吧.

 # 自己动手,编写代码--hiwifiOS交叉编译环境的搭建

根据网上主流的做法,配置OpenWrt需要在Linux环境下进行.不过我想直接在Windows下直接进行这个环境的搭建.当然了,也是借助一些模拟Linux的环境进行搭建.</br>首先介绍一个软件 ` bash on Ubuntu on Windows ` 听这个软件名字这么长就知道这个很厉害了吧.这是微软爸爸最新弄出来的软件,正式版只能在最新的Windows 10 1709版本运行.这是一个Ubuntu运行环境,相当于在Windows上面运行了一个Ubuntu命令行版本的虚拟机,不过呢,这个环境底层又是直接调用的Windows系统级API,运行速度会比单纯的虚拟机快上很多,而且文件共享也更方便.
### 安装bash on windows
安装过程非常简单,在Windows的程序和功能中选择`启动或关闭Windows功能` 然后勾选`Linux子系统`,重启之后再去应用商店下载Ubuntu即可.

![](
http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE11.png )

![](
http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE12.png )

> 打开PowerShell或者CMD,输入Ubuntu,这个运行环境就搭建完成了.

![](
http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE13.png)

之后的操作和在真正的Ubuntu下操作终端就完全一样了,唯一需要注意的是和Windows文件交换的问题.整个Windows的文件都被挂载到 /mnt 文件夹下了,于是可以通过这个 /mnt文件夹方便的实现文件的交换.另外,系统默认使用root账户登录,权限高,在虚拟环境下又不会对Windows产生伤害,美滋滋.

### bash on Windows的完善
其实这一部分没什么好说的,一句话总结,操作和Linux下完全一样.</br>
比如换成国内的软件源 使用命令`vi /etc/apt/sources.list`保存源的文件,替换成国内的源即可.比如:

```
#deb cdrom:[Ubuntu 16.04 LTS _Xenial Xerus_ - Release amd64 (20160420.1)]/ xenial main restricted
deb-src http://archive.ubuntu.com/ubuntu xenial main restricted #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse #Added by software-properties
deb http://archive.canonical.com/ubuntu xenial partner
deb-src http://archive.canonical.com/ubuntu xenial partner
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse
EOF 
```
之后再 `` apt-get update`` 更新软件源就好了

顺便安装一些常用的软件
* apt-get install gcc  安装gcc C语言编译器
* apt-get install g++  安装g++ C++编译器

其他我就不列举了,重点说一下安装Java.安装java有两种方式,可以使用apt-get安装,这种方式不用自己配置环境变量.另外也可以去Oracle官网下载java的安装包手动配置环境变量进行安装.这里就说第一种安装方式吧.</br>
* ``add-apt-repository ppa:webupd8team/java`` 添加java的源
* ``apt-get update`` 更新软件源
* ``apt-get install oracle-java9-installer`` 安装Java安装包

经过这三步之后,java安装包就会自动安装java了,等一会就好.值得注意的是,我们这里安装的是最新的java9,安装其他版本只需要把9改成其他数字就好了

### 安装SDK,交叉编译工具链正式开始搭建

> 此部分内容主要参考hiWiFi的官方文档 [code.hiwifi.com](http://code.hiwifi.com/docs/sdk_usage)

说句实话,OpenWrt工具链的搭建,网上资料真的是少之又少.感觉基本上就只有官方的帮助文档和几篇博文能看.另外,官方的帮助文档我只能用**简洁**二字来形容.只有十几页内容介绍完了编译环境搭建到刷机到全部的api接口......

根据官方的说法,先下载SDK包,直接说吧 hiwifiOS应该下载这一个[mtmips](http://sdk.ikcd.net/mtmips-sdk.tar.bz2) 使用前面讲的wget命令下载到电脑上就好了.下载完成后解压,` tar -xjvf [文件名] ` 到目前为止,sdk已经下载完成了.其实吧,在Windows上也可以完全用浏览器下载下载下来,然后用图形化的解压缩工具解压缩.

继续阅读官方SDK 需要安装一些工具库,按照官方说的来就好了
```
apt-get install subversion git build-essential libncurses5-dev zlib1g-dev gawk unzip gettext libssl-dev intltool openjdk-6-jre-headless optipng

ln -sf bash /bin/sh
```
这个时候可能会弹出来说啥java6安装不上啥的.没关系,反正就是jre(java runtime environment)嘛,我们之前不就已经安装了java吗.

好了,如果没有出错的话,到目前位置,交叉编译环境就已经搭建好了.

# Hi~ WiFi! 第一个在路由器上运行的程序
### 编译方法
上节说到交叉编译环境搭建.来来来,这节就该说说编译程序了.按照hiwifi的说明,有两种编译方法,我们这里使用脚本编译的方法.</br>cd 到sdk的根目录输入` ./scripts/cross-compile.sh ./ `启动这个编译脚本,cd到packge目录下你的要编译的文件的文件夹下执行`make`指令就好了.之后可以执行`file [编译出的文件名]`查看是不是mips架构的可执行文件,如果是的话那么祝贺,编译成功了!

### 编写第一个程序
等等,漏了什么重要的东西,编译啥啊,啥都还没有呢.......可以在Windows下写好一个c语言程序,再编写一个makefile,再放到sdk的packge文件夹下就好了,比如这样:

![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE111.png)

makefile的作用就是制定编译的顺序,以下是一个简单的makefile
```makefile
main : hello.c
    gcc hello.c -o main
```
### 编译遇到的错误
编写完成之后就执行刚才的操作,那么一切顺利的话就编译完成了.当然,事情也不会有那么顺利,有时候会编译报错,提醒你这没安装那没安装的.比如我第一次配置环境的时候就一直提醒我git没安装,可是我真的安装了的啊,后来发现是中文路径搞的鬼,SDK一定要放到一个全部是英文的路径下面,不然,可能就会像我一样出现一些奇奇怪怪的问题.

### 将程序传输到路由器上
好了,到目前为止就只剩下最后一个操作了,把文件传到路由器上去.用WinSCP传输文件就好了.看图!

![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE112.png)

左边是电脑上的文件,右边是路由器上的文件,直接拖拽过去就上传成功了.
</br>接下来,ssh连接路由器,执行.啊?无法执行?哦哦,忘了添加执行权限了,输入命令,添加就好 `chmod 777 [文件名]` 777就是添加可执行权限的代号
.最后执行! 运行正常,完美!上图!

![](	http://zzshubimage-1253829354.file.myqcloud.com/hiwifi%E7%9A%84%E6%AD%A3%E7%A1%AE%E6%89%93%E5%BC%80%E6%96%B9%E5%BC%8F/%E8%8D%89%E5%9B%BE113.png)

终于成功了,激动!
