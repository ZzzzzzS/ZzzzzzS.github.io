---
title: 安装黑苹果并启用secure boot
date: 2020-10-22T23:22:12+08:00
tags: [Hacintosh]
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
cover: https://zzshubimage-1253829354.cosbj.myqcloud.com/iar7.8Bug/u%3D1593298829%2C2003225384%26fm%3D27%26gp%3D0.jpg
---

# 在ASUS ROG枪神3上安装黑苹果并启用secure boot

> 最近瞎折腾黑苹果，其实装黑苹果现在倒是挺简单，去 ~~~gayhub~~~ github上找EFI，再去找个系统镜像，并做个启动盘，改下EFI就差不多行了。如果实在有搞不定的硬件，现在有各种渠道找人来远程做一下也挺方便。但是我发现有关secure boot的资料太少了，而且这些方法我用着都或多或少有问题，没法完全成功，因此在这里记录一下我安装的步骤，也算是提供一种不同的解决方案吧。

# 安装黑苹果

安装过程网上资料很多，这里简单记录一些注意事项和安装工具。

* <font color=#ff0000 size=3>**注意Windows如果开启了bitlocker请一定要找到还原密钥再进行操作，不然会导致bitlocker被锁住！！！**</font> 

* 注意安装前需要在bios中关闭secure boot

* Mac硬盘刻录工具transmac，下载地址：[https://www.acutesystems.com/scrtm.htm](https://www.acutesystems.com/scrtm.htm) 有15天试用期，不需要破解，反正就用一下，下次要用重新安装一下就好，本人极度鄙视破解软件等盗窃知识产权的行为！

* 黑果小兵的博客，[https://blog.daliansky.net](https://blog.daliansky.net/)，里面有各种黑苹果的教程，EFI文件以及镜像，非常好用

* 枪神3的EFI文件，下载地址：[https://github.com/DongLinghe/ROG-SCAR-III-Hackintosh-EFI](https://github.com/DongLinghe/ROG-SCAR-III-Hackintosh-EFI)，支持macOS 10.15.3 bug: WiFi（可以通过更换网卡修复）独立显卡（无解） 就目前来讲完美，键盘无法调节亮度的话就在设置里改快捷键，可以看看这个项目的Issues里有说。其它机型的EFI去黑果小兵的博客或者 ~~~gayhub~~~ github找

# 让黑苹果也能用上secure boot

> 刚才简单记录了一下黑苹果的安装，下面进入正题——secure boot

## secure boot是什么以及为什么需要secure boot

UEFI安全引导（Secure Boot）的核心职能就是利用数字签名来确认EFI驱动程序或者应用程序是否是受信任的。[1]

这个东西的大概意思就是说对系统的bootloader进行限制，只有经过签名认证的系统才能被启动，这样可以有效防止很多恶意程序的运行。比如在Windows boot manager启动以前就偷偷插入一段恶意程序的bootloader，然后再启动Windows boot manager，由于启动顺序早于操作系统，所以权限很高，操作系统也很难防御，并且启动过程隐蔽，用户也很难发现，这样会带来很大的安全问题，因此我们需要secure boot来让只被允许的bootloader启动。



## 为什么黑苹果和secure boot会有关系

由前文所述，secure boot只允许受过签名的boot loader启动。UEFI 规定，主板出厂的时候，可以内置一些可靠的公钥。然后，任何想要在这块主板上加载的操作系统或者硬件驱动程序，都必须通过这些公钥的认证。也就是说，这些软件必须用对应的私钥签署过，否则主板拒绝加载。[2]常用的操作系统都有签名，但是我们的黑苹果没有，因此就需要自己插入一个公钥然后用自己的签名，或者找一个签了名的prebootloader来启动bootloader。

虽然关闭secure boot就能正常使用黑苹果，但是部分机型关闭secure boot后启动界面就会变成很难看的大红色(surface系列)，并且出于安全方面的考虑，也必须要打开secure boot

## 让secure boot支持黑苹果

由前文所述，有两种方式来支持。这里选择的是第二种，也就是利用已经签名的bootloader来load黑苹果的boot loader。这里使用了 ~~~gayhub~~~ github上找的[Super-UEFIinSecureBoot-Disk](https://github.com/ValdikSS/Super-UEFIinSecureBoot-Disk)项目。

抄一段它的核心功能：
> disk is fully functional with UEFI Secure Boot mode activated. It can launch any operating system or .efi file, even with untrusted, invalid or missing signature.

根据这个项目的描述，我们需要用它提供的一个镜像做启动盘，然后这个启动盘会自动添加一个公钥进UEFI，在然后我们用这个启动盘里的EFI文件夹下的boot文件夹替换黑苹果的boot文件，最后再将clover文件夹下的bootx64.efi改名为grubx64_real.efi并复制到boot文件夹下，就好了。最后在UEFI中打开secure boot也能用了。

**但实际上它提供的启动盘并不能在我的电脑上启动(能启动的可以参考这个项目的文档，不能启动的看我操作)。**这个启动盘干的工作就是往UEFI里注册了一个公钥，我们自己来手动注册也可以，步骤如下。


* 首先制作启动盘，制作工具和镜像链接在后文有提到，制作完成后如下图所示。
![2601694036151687](https://zshubimage-1253829354.cosbj.myqcloud.com/media/image/2601694036151687.jpg)

  其中``ENROLL_THIS_KEY_IN_MOKMANAGER.cer``就是需要注册的公钥文件。

* 之后进入UEFI设置，注意不同机型可能存在差异，在secure->secure boot选项卡中选择 ``key exchange keys``

![03698316002590052](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/media/image/03698316002590052.jpg)

* 选择``Append``添加证书

![014435539452277268](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/media/image/014435539452277268.jpg)

* 选择``No``从外部设备添加

![07049956718966244](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/media/image/07049956718966244.jpg)

* 找到启动盘，并添加``ENROLL_THIS_KEY_IN_MOKMANAGER.cer``

![40736526710036935](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/media/image/40736526710036935.jpg)

![9272594442544191](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/media/image/9272594442544191.jpg)

好了，到这里为止公钥就添加好了，之后的步骤就是和项目里所述的相同了。

* 将启动盘``/EFI/boot/``中的所有文件复制到黑苹果的``/EFI/boot/``中

* 将黑苹果``/EFI/clover/bootx64.efi``文件复制到黑苹果的``/EFI/boot/``中并改名为``grubx64_real.efi``

* 在UEFI中打开secure boot，并可以正常进入黑苹果系统。

# 资料下载

镜像文件：[https://github.com/ValdikSS/Super-UEFIinSecureBoot-Disk/releases/download/3/Super-UEFIinSecureBoot-Disk_minimal_v3.zip](https://github.com/ValdikSS/Super-UEFIinSecureBoot-Disk/releases/download/3/Super-UEFIinSecureBoot-Disk_minimal_v3.zip)

启动盘写入工具：[https://www.balena.io/etcher/](https://www.balena.io/etcher/)

# 参考文献

* [1] 作者：老狼
链接：https://zhuanlan.zhihu.com/p/25279889
来源：知乎

* [2] 作者: Bugprogrammer
链接: https://www.bugprogrammer.me/2019/07/06/clover-with-secure-boot.html
来源: Bugprogrammer的博客

***
EOF
