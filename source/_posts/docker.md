---
title: Docker for Windows 使用初探
date: 2020-01-29 00:00:23
tags: [docker]
mathjax: false
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
cover: https://zzshubimage-1253829354.file.myqcloud.com/docker/vertical-logo-monochromatic.png
---

> 一直以来都听说docker功能十分强大，最近闲来无事终于稍微研究了一下，确实是一个强大的工具。昨晚利用docker部署了一个webdav服务器，几分钟就弄好了，如果使用传统方法我可能甚至会搞一晚上，还容易把系统搞的一地鸡毛。利用docker可以做到开箱即用，非常方便。

# docker架构

Docker 包括三个基本概念:

* 镜像（Image）：Docker 镜像（Image），就相当于是一个 root 文件系统。比如官方镜像 ubuntu:16.04 就包含了完整的一套 Ubuntu16.04 最小系统的 root 文件系统。
* 容器（Container）：镜像（Image）和容器（Container）的关系，就像是面向对象程序设计中的类和实例一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。
* 仓库（Repository）：仓库可看着一个代码控制中心，用来保存镜像。

容器与镜像的关系类似于面向对象编程中的对象与类。

|docker|面向对象|
|------|-------|
|容器|对象|
|镜像|类|

以下是docker for Windows的大致结构图，对用户来说我们只需要管最上面的image和container两层即可。

![](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/docker/%E7%BB%98%E5%9B%BE2.png)



# 在Windows上安装docker

关于在Windows上安装docker的具体过程官方已经给出详细过程，本文就不再赘述，这里主要补充一些我在安装过程中遇到的问题。docker的安装详细步骤参见[docker官网](https://hub.docker.com/?overlay=onboarding)(可能需要注册docker账户来查看)

* docker需要hyper-v服务
和在Linux上能直接运行Linux的docker容器不同，如果在Windows上要运行Linux容器就需要使用虚拟机来提供一个Linux的内核环境。Windows的docker使用的是Windows专业版自带的hyper-v虚拟机(貌似家庭版可以强行打开hyper-v)。所以安装docker以前需要打开Windows的hyper-v功能，若还需要Windows的docker容器就还需要打开Windows的Container功能，这些功能都可以在``控制面板->程序和功能->启用或关闭Windows功能``中找到。安装过程中可能需要重新启动计算机。

![](https://zzshubimage-1253829354.file.myqcloud.com/docker/hyperv.png)

* hypervisor冲突问题
在目前的计算机上一般只能存在一个hypervisor，所以使用hyper-v之前需要卸载VMware的全部服务(貌似有强行让docker运行在VMware上的方法)，个人认为hyper-v还挺好用的，还可以和Windows自带的应用程序防护，内核防护等功能配合使用，为系统提供额外的安全防护功能。

![](https://zzshubimage-1253829354.file.myqcloud.com/docker/6F53DBC5-037D-417B-A01A-3D9E6AD3D5B2.PNG)

hyper-v是典型的type1型虚拟机

* 建议在官网安装新版docker
最开始随便找了一个版本的docker安装上，但是重启电脑之后所有已经建立好的容器都无法打开，原因未知，重新安装最新版docker之后问题解决。

# 获取镜像

关于镜像的获取可以访问[docker hub的官方网站](https://hub.docker.com/)，这里不仅有镜像的下载方法，也有容器的简单使用说明。

![](https://zzshubimage-1253829354.file.myqcloud.com/docker/webdav.png)

上图是[webdav](https://hub.docker.com/r/idelsink/webdav)镜像的主页.

以下是docker和镜像管理相关的命令

|操作|命令|示例|备注|
|---|---|---|---|
|搜索镜像|docker search [搜索的镜像]|docker search webdav|
|拉取镜像|docker pull [镜像名称]:[版本号]|docker pull idelsink/webdav|若不指定版本号就自动获取最新的版本|
|查看本地镜像|docker images||
|删除本地仓库|docker rmi [镜像名称]|docker rmi ubuntu|可以同时删除多个镜像|
|登录到docker hub|docker login||开启两步验证后需要输入设置的token而不是密码|

# 创建和运行容器

获取镜像之后就可以利用镜像运行容器了，运行容器相关的命令如下

|操作|命令|参数|示例|解释|
|---|---|---|---|---|
|创建容器 **[1]**|docker create [参数] [要使用的镜像] [要运行的指令] [要执行的命令的附加参数]||docker create ubuntu bash||
|创建并运行容器|docker run [参数] [要使用的镜像] [要运行的指令] [要执行的命令的附加参数]||docker run ubuntu bash|新建并运行Ubuntu镜像的容器，启动时执行bash命令|
|||-it|docker run -it ubuntu bash|运行交互式的容器，相当于前台启动这个容器里的bash终端 **[2]**|
|||-d|docker run -d  idelsink/webdav|后台启动容器，容器启动后直接在后台运行，不占用前台终端，并返回容器的ID|
|||-p [容器中的端口]:[本机的端口]|docker run -d -p 80:80 idelsink/webdav|将容器中的80端口映射到本机的80端口，这样就能访问容器中的80端口了。|
|||-v [本机地址]:[容器内的地址]|docker run -v C:\Users:/mnt/C -d -p 80:80 idelsink/webdav|将本机的文件路径挂载到容器内指定的位置，这里是将``C:\Users``挂载到``/mnt/C``位置下 **[3]** **[4]**|
|||-w [容器内的地址]|docker run -w /home -it ubuntu bash|指定容器的工作路径，相当于启动容器时所在的文件位置| 
|||--name |docker run -v <path to location>:/webdav -p 80:80 --name=webdav -d idelsink/webdav|指定容器的名称，这里是指定容器名称为webdav|

**注意事项**

* 容器在创建之后就无法修改挂载地址和端口号等，所以创建的时候一定要仔细考虑

* 事实上 -it是-i 和-t两个命令，分别是 在新容器内指定一个伪终端或终端 和 允许你对容器内的标准输入 (STDIN) 进行交互，通常连在一起使用。

* 需要注意的是``-v``需要紧跟在``docker run``后面，否则会挂载不上

* 使用挂载前需要在docker setting中打开文件共享功能

![](https://zzshubimage-1253829354.file.myqcloud.com/docker/fileshare.png)



# 使用容器

|操作|命令|参数|示例|解释|
|---|---|---|---|---|
|执行命令|docker exec [参数] [容器名称] [命令] [要执行的命令的附加参数]||docker exec blog hexo g|在blog容器中执行``hexo g``命令|
|||-it|docker exec -it blog bash|运行交互式的容器|
|||-d|docker exec -d blog hexo s|后台运行容器|
|||-e||附加环境参数|

# 管理容器

|操作|命令|参数|示例|解释|
|---|---|---|---|---|
|启动容器|docker start [容器名称]||docker start blog|启动blog容器|
|停止容器|docker stop [容器名称]||docker stop blog||
|强行停止容器|docker kill [容器名称]||docker kill blog||
|重启容器|docker restart [容器名称]||docker restart blog|
|删除容器|docker rm [容器名称]||docker rm ubuntu|
|查看正在运行的容器|docker ps|||
|||-a||查看最近运行过还没有删除的容器(包括正在运行的容器)|
|容器改名|docker rename [旧名称] [新名称]||docker rename nostalgic_feynman blog|

在也可以使用最新版docker自带的dashboard来图形化的控制docker，但这个其实不是很好用。

![](https://zzshubimage-1253829354.file.myqcloud.com/docker/dashboard1.png)

![](https://zzshubimage-1253829354.file.myqcloud.com/docker/dashboard2.png)

> 其它docker命令可参阅[这里](https://www.runoob.com/docker/docker-command-manual.html)或者[docker官网网站](https://docs.docker.com/docker-hub/)

# 在WSL中使用使用docker

目前wsl中无法运行docker engine(据说也可以运行，没研究)，所以在wsl中运行docker实际上是利用wsl远程连接到本机的docker上来运行的，和直接在power shell中运行没有区别。

* 首先需要在docker setting中打开此选项

![](https://zzshubimage-1253829354.file.myqcloud.com/docker/wsl.png)

* 其次在wsl中安装docker
```
apt-get install docker.io
```

* 最后配置wsl的环境
将此命令加入到用户的环境变量中
```
export DOCKER_HOST=tcp://127.0.0.1:2375
```
到这里应该就能在wsl中使用docker了

![](https://zzshubimage-1253829354.file.myqcloud.com/docker/wsldockertest.png)

# 在~~AWSL~~WSL2中使用docker

最新版docker已经支持在 ~~AWSL(Advanced Windows Subsystem for Linux)~~ WSL2(Windows Subsystem for Linux 2)中使用docker，目前这是一个实验性功能，需要在Windows 10 build 19018以上系统中才能使用。目前系统条件所限暂时没有研究，awsl就完事了。

***

EOF