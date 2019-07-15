---
title: mathjax数学公式编辑工具
date: 2018-05-04 14:12:32
tags: [mathjax,hexo,blog]
mathjax: true
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
cover: https://zzshubimage-1253829354.cosbj.myqcloud.com/mathjax/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-05-04%2005.42.45%20PM.png
---

# mathjax数学公式编辑工具使用简介

>数学在各个学科的许多方面有许多重要的用途。本文主要研究利用数学公式编辑工具**mathjax**快速编辑复杂数学公式。本文主要研究**mathjax**的使用，关于它的安装配置等本文将不做深入讨论。关于[mathjax](https://www.mathjax.org)在[hexo](https://hexo.io)博客系统下的配置可以[点击这里](https://github.com/hexojs/hexo-math)

# 显示效果

$$ \iiint_v(\sum_{i=0}^{\infty}\frac{\partial{(xy_i}+\sqrt[5]{y_i^2})}{\partial{x}})dv   $$

# 基础语法
## 公式显示
公式显示一共有两种方式,一种是行内显示如$\frac{a^2_i}{b}$,而另一种是单独显示,就像上文那个例子那样.在markdown中显示数学公式都需要特定的标识符,行内显示使用单个``$``来确定显示的内容,例如``$ a=b^2 $``那么输出效果就是$a=b^2$ .独立显示使用``$$``,例如`` $$ a=b^2 $$ ``
$$ a=b^2$$

另外如果公式有多行,可以使用 和 来包含多行内容,例如


$$
\begin{aligned}
\dot{x} & = \sigma(y-x) \\
\dot{y} & = \rho x - y - xz \\
\dot{z} & = -\beta z + xy
\end{aligned}
$$


$$
\begin{aligned}
\dot{x} & = \sigma(y-x) \\
\dot{y} & = \rho x - y - xz \\
\dot{z} & = -\beta z + xy
\end{aligned}
$$

另外,如果要使用\$符号,可以输入``\$`` 

## 上标和下标
在mathjax中使用``^``表示商标,如``b^2``表示 $b^2$,用``_``表示下标,例如``a_i``表示$a_i$.

## 成组
用``{}``来标记一组数据,例如``b^{21}``表示$b^{21}$,而``b^21``则被解释为$b^21$.普通的大括号可以使用``\{`` ``\}``来表示

## 转义字符
在mathjax中各个符号都是用转义字符来实现的,例如``\partial``表示$\partial$ ,``\sum``表示$\sum$,结合上文所述的上下标可以知道``\sum_{i=0}^n``表示$\sum_{i=0}^n$.一般情况下可用\来作转义，但如果想要表示\本身，需要用``\backslash``，因为\\表示换行.

# 常用计算符号

> 下面列出一些标量计算中常常会使用到的符号

### 常用字母

|符号|效果|备注|
|---|----|---|
|\infty|$\infty$|
|\pi|$\pi$||
|\alpha|$\alpha$||
|\\varepsilon|$\varepsilon$||
|\beta|$\beta$||
|\gamma|$\gamma$||
|\theta|$\theta$||
|\eta|$\eta$||
|\lambda|$\lambda$||
|\varphi|$\varphi$||
|\mu|$\mu$||
|\nu|$\nu$||
|\xi|$\xi$||
|\rho|$\rho$||
|\sigma|$\sigma$||
|\Delta|$\Delta$||
|\Omega|$\Omega$||
|\Psi|$\Psi$||
|Sigma|$\Sigma$||


### 基本运算符号

|符号|效果|备注|
|---|----|---|
|\ast|$\ast$||
|\times|$\times$||
|\div|$\div$||
|\frac{}{}|$\frac{a}{b}$|可以支持复杂多重分式|
|\sqrt[n]|$\sqrt[n]{a}$||
|\vert|$\vert$|绝对值符号|
|\pm|$\pm$||
|\mp|$\mp$||
|\cap|$\cap$||
|\cup|$\cup$||
|\leq|$\leq$||
|\geq|$\geq$||
|\ll|$\ll$||
|\gg|$\gg$||
|\approx|$\approx$||
|\neq|$\neq$||
|\ni|$\ni$||
|\in|$\in$||
|\lgroup|$\lgroup$|大小会变化|
|\rgroup|$\rgroup$|大小会变化|
|\lim{a \to b}|$$\lim_{a \to b}$$||

### 积分和导数

|符号|效果|备注|
|---|----|---|
|\sum|$\sum$||
|\prod|$\prod$||
|\int|$\int$|多重积分就多几个i|
|\oint|$\oint$||
|\partial|$\partial$||

### 向量和几何

|符号|效果|备注|
|---|----|---|
|\mathbf{a}|$\mathbf{a}$|向量中的加粗字体|
|\overrightarrow{abc}|$\overrightarrow{abc}$||
|\overleftarrow{abc}|$\overleftarrow{abc}$||
|\overline{abc}|$\overline{abc}$||
|\underline{abc}|$\underline{abc}$||
|\nabla|$\nabla$||
|\angle|$\angle$||
|\cdot|$\cdot$||
|\because|$\because$||
|\therefore|$\therefore$||
|\dot{}|$\dot{a}$|多加一个d就多一个点|


# 矩阵

可以用 ``$$\begin{matrix}…\end{matrix}$$`` 来表示矩阵。将矩阵元素放在 \begin 和 \end 之间即可。 用 \\ 来分割行，用 & 来分割同一行的矩阵元素。如：

```
$$
\begin{matrix}
	1 & x & x^2 \\
	1 & y & y^2 \\
	1 & z & z^2 \\
\end{matrix}
$$
```

$$
\begin{matrix}
	1 & x & x^2 \\
	1 & y & y^2 \\
	1 & z & z^2 \\
\end{matrix}
$$

### 增广矩阵

用到{array}语句,{cc|c}的作用是在第二列和第三列之间画一条垂直线,例如:
```
    \begin {array} {cc|c}
      1&2&3\\
      4&5&6
    \end {array}
```
$$
    \begin {array} {cc|c}
      1&2&3\\
      4&5&6
    \end {array}
$$

### 矩阵符号

|符号|效果|备注|
|---|----|---|
|\cdots|$\cdots$||
|\vdots|$\vdots$||
|\ddots|$\ddots$||
|pmatrix|$$\begin{pmatrix}1 & x & x^2 \\1 & y & y^2 \\1 & z & z^2 \\\end{pmatrix}$$||
|bmatrix|$$\begin{bmatrix}1 & x & x^2 \\1 & y & y^2 \\1 & z & z^2 \\\end{bmatrix}$$||
|Bmatrix|$$\begin{Bmatrix}1 & x & x^2 \\1 & y & y^2 \\1 & z & z^2 \\\end{Bmatrix}$$||
|vmatrix|$$\begin{vmatrix}1 & x & x^2 \\1 & y & y^2 \\1 & z & z^2 \\\end{vmatrix}$$||
|Vmatrix|$$\begin{Vmatrix}1 & x & x^2 \\1 & y & y^2 \\1 & z & z^2 \\\end{Vmatrix}$$||


# 以下是所有支持的符号

这是PDF版本的[下载链接](https://zzshubimage-1253829354.file.myqcloud.com/mathjax/maths-symbols.pdf.pdf)

![](https://zzshubimage-1253829354.file.myqcloud.com/mathjax/IMG_2987.JPG)

