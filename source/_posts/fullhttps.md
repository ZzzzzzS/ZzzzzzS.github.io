---
title: GitHub Pages开启全站https连接
date: 2018-09-17 00:00:00
tags: [github,blog]
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
cover: https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/%E5%85%A8%E7%AB%99https/20180522ssl.png
---
>好久没更新博客了,最近想写博客时发现travis-CI自动部署系统用不了了,本地也用不了了,问题还不一样.弄了小半个下午才弄好.应该是某个插件更新了导致的一些错误,再加上本地的python版本有问题,导致都没法用还显示错误不一样.别人的博客框架确实好用,但是除了问题震荡还是有点麻烦的.whatever,修好了就好了.
# GitHub Pages开启全站https安全连接
最近Chrome69版本发布修改了https的显示方式,于是我又了解了一下https,意识到我的博客还是用的http连接非常不安全怎么办啊,于是在最近全部升级成了https连接(其实就是强迫症犯了觉得那个小锁很好看也想要一个).

![](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/%E5%85%A8%E7%AB%99https/%E6%97%A0%E6%A0%87%E9%A2%98.png)

>升级成https后的显示效果

# 开启GitHub Pages强制https

全站https访问需要禁止http访问才有意义,这一步很简单,直接在项目的设置界面中的GitHub Pages那里打勾就好

![](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/%E5%85%A8%E7%AB%99https/%E8%8D%89%E5%9B%BE.png)

>貌似以前自定义域名开启https还很麻烦,**但是**现在GitHub升级了,一切都变得容易了起来.

# 全部资源使用https

完成上一步后打开网站发现使用https连接但是还是没有小绿锁.因为很多资源比如图片还是使用http连接加载的所以不能不能认为是安全的网站所以没有小锁.要实现有小锁就必须全部资源使用https连接才行.

![](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/%E5%85%A8%E7%AB%99https/%E8%8D%89%E5%9B%BE2.png)

将全部图床图片等其他外链全部设置成https后小锁就出现了.

# 写在最后
其实安全证书还有很多级别,仔细观察发现我的小锁图标和[GitHub](https://github.com/)还是有区别的,GitHub采用的拓展的安全证书,更加安全.