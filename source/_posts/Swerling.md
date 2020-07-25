---
title: 基于Swerling目标模型的雷达信号检测
date: 2020-01-28 22:00:23
tags: [数字信号处理,雷达原理]
mathjax: true
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
cover: https://zzshubimage-1253829354.file.myqcloud.com/Swerling/MatlabLogo.png
---

> 雷达散射截面积(RCS)是表征雷达散射雷达信号强弱的物理量，随着雷达入射角的改变而起伏变化，起伏的RCS导致雷达检测概率、链路损耗均发生改变，为了准确地表述RCS的起伏特性，人们建立了RCS分布的统计模型，最为典型的是非起伏模型和Swerling起伏模型。

# 设计任务和要求

产生不同类型的目标模型数据，按照虚警概率要求，对不同信噪比时的检测性能进行仿真，并分析仿真结果，给出结论。
设雷达为平方律检波，检波后进行10个脉冲的非相参积累然后进行信号检测。要求产生Swerling0~IV型目标信号，设噪声为高斯白噪声，要求对信噪比SNR在[-10dB:1dB:10dB]变化范围内分别进行至少$ {10}^5 $次蒙特卡洛仿真，虚警概率为$ {10}^{-6} $。根据仿真结果画出检测性能曲线（横坐标为SNR,信噪比按照1dB为步长而变化，纵坐标为检测概率Pd）。

# 5类Swerling模型

* Swerling0型：非起伏目标，雷达截面积$ \sigma $ 是个固定值。

* SwerlingI型：目标回波幅度在一次扫描内恒定，在扫描与扫描间独立，称为慢起伏目标。回波服从瑞利分布。

* SwerlingII型：目标回波幅度在脉冲与脉冲间独立，称为快起伏目标。其回波振幅也服从瑞利分布。

* SwerlingIII型：慢起伏目标，回波振幅服从莱斯分布。

* SwerlingIV型：快起伏目标，回波振幅也服从莱斯分布。

Swerling1、2型适用于由大量近似相等单元散射体组成的复杂目标，虽理论上要求独立散射体的数量很大，实际上只需要四五个即可。
Swerling3、4型适用于由一个较大反射体和许多小反射体合成的目标，或者一个大的反射体在方位上有小变化的目标。

![](https://zzshubimage-1253829354.file.myqcloud.com/Swerling/swerling.png)

上图是5种Swerling模型分布函数的图像

# 概念理解


## 蒙特卡洛仿真

以概率和统计理论方法为基础的一种计算方法，是使用随机数（或更常见的伪随机数）来解决很多计算问题的方法。将所求解的问题同一定的概率模型相联系，用电子计算机实现统计模拟或抽样，以获得问题的近似解。

## $ x^2 $分布

若n个相互独立的随机变量$ \xi_1,\xi_2\ldots\ldots\xi_n $，均服从标准正态分布（也称独立同分布于标准正态分布），则这n个服从标准正态分布的随机变量的平方和构成一新的随机变量，其分布规律称为卡方分布（chi-square distribution）。

$$ f\left(x\right)=\frac{1}{2^\frac{n}{2}\Gamma\left(\frac{n}{2}\right)}e^{-\frac{x}{2}}x^{\frac{n}{2}-1},x>0 $$

其中$\Gamma\left(s\right)$是Gamma函数$\Gamma\left(s\right)=\int_{0}^{\infty}{t^se^{-t}}dt$

## 瑞利分布

瑞利分布（Rayleigh Distribution）:当一个随机二维向量的两个分量呈独立的、有着相同的方差的正态分布时，这个向量的模呈瑞利分布。

$$ f\left(x\right)=\frac{x}{\sigma^2}e^{-\frac{x^2}{2\sigma^2}},x>0 $$

## 莱斯分布

莱斯分布实际上可以理解为主信号与服从瑞利分布的多径信号分量的和。概率密度函数公式中，R即为正弦（余弦）信号加窄带高斯随机信号的包络，参数A是主信号幅度的峰值，$ \sigma^2 $是多径信号分量的功率，$ I_0 $是修正的0阶第一类贝塞尔函数。

$$ P\left(R\right)=\frac{R}{\sigma^2}e^{\left(-\frac{R^2+A^2}{2\sigma^2}\right)}\cdot I_0\left(\frac{RA}{\sigma^2}\right) $$


# 仿真结果

![](https://zzshubimage-1253829354.cos.ap-beijing.myqcloud.com/Swerling/all.bmp)

> 这是仿真次数为100000次的结果，曲线光滑，但是运行速度慢，降低仿真次数可加快运行速度但将导致曲线不平滑

综合以上仿真分析，说明目标起伏及起伏快慢均会对目标检测性能造成影响。当需要较高检测概率时，起伏目标需要更大的SNR，而非起伏目标需要较小的SNR，并且慢起伏目标比快起伏目标需要更大的SNR。这是因为慢起伏目标SwerlingI和III型目标的回波幅度从一个脉冲到下一个脉冲是相关的，当检测门限大于第一个脉冲振幅时，后面的脉冲振幅也将小于检测门限，除非目标信噪比变大，否则无法被检测到。而对于快起伏目标（SwerlingII和IV型目标），其回波幅度从一个脉冲到下一个脉冲是不相关的，间隔脉冲的振幅各不相同，因此只要有一个脉冲的振幅超过检测门限目标就可被检测到，并不需要提高目标信噪比。并且，如果脉冲积累个数够多，快起伏目标的检测概率是多个脉冲积累个数下检测概率的平均值。

# 工程源码

``` matlab
clear;clc;
Np = 10;%非相参积累的次数
Pfa = 1e-6;%虚警概率
Vt = gammaincinv(1-Pfa,Np);%求门限
Mc_number=10000;
%--------------------------------------------------------------------------
%定义中间变量以及存储矩阵
X0 = zeros(21,Np); X1 = zeros(21,Np); X2 = zeros(21,Np);X3 = zeros(21,Np);X4 = zeros(21,Np); %加噪声后的信号
X0sum = zeros(21,Mc_number);X1sum = zeros(21,Mc_number);X2sum = zeros(21,Mc_number);X3sum = zeros(21,1);X4sum = zeros(21,Mc_number); %检测出的次数
S0 = zeros(21,Np);S1 = zeros(21,Np);S2 = zeros(21,Np);S3 = zeros(21,Np);S4 = zeros(21,Np); %信号幅度加相位
A0 = zeros(21,1);A1 = zeros(21,1);A2 = zeros(21,Np);A3 = zeros(21,1);A4 = zeros(21,Np); %信号幅度

Sum0=zeros(21,Mc_number); Sum1=zeros(21,Mc_number); Sum2=zeros(21,Mc_number); Sum3=zeros(21,Mc_number); Sum4=zeros(21,Mc_number);
Pd0=zeros(21,1); Pd1=zeros(21,1); Pd2=zeros(21,1); Pd3=zeros(21,1); Pd4=zeros(21,1);%检测概率
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%蒙特卡洛循环，
for Mc = 1:Mc_number%循环次数为100000 非常耗时间

for Num = 0:20
    SNR = Num-10;% 信噪比
    %----------------------------------------------------------------------
    %设定噪声功率
    sigs1 = sqrt((10^(SNR/10)));%db转化为幅度
    %-----------------------------------------------
    %Swerling 0
    A0(Num+1,1) = sqrt(1*(10^(SNR/10)));% 幅度
    S0(Num+1,:) = A0(Num+1,1)*exp(1i*2*pi*rand(1,Np));%信号（包含幅度和相位的）
    X0(Num+1,:) = abs(awgn(S0(Num+1,:),SNR,'measured')).^2;%包含噪声，符合信噪比的信号加噪声  幅度 接受以dBW为单位的输入信号功率值
    X0sum(Num+1,Mc) = sum(X0(Num+1,:));% X0  检测出信号总计 
    if X0sum(Num+1,Mc) >= Vt
        Sum0(Num+1,Mc) = 1;%  第几次仿真  检测出了信号  为1
    end
    %------------------------------------------------
    %Swerling 1
    %randn 标准正态
    %rand 0-1均匀随机
    %awgn 加高斯信号
    A1(Num+1,1) = sqrt(((sqrt(1/2)*sigs1*randn(1))^2)+((sqrt(1/2)*sigs1*randn(1))^2));
    S1(Num+1,:) = A1(Num+1,1)*exp(1i*2*pi*rand(1,Np));
    X1(Num+1,:) = abs(awgn(S1(Num+1,:),SNR,'measured')).^2;
    X1sum(Num+1,Mc) = sum(X1(Num+1,:));
    if X1sum(Num+1,Mc) >= Vt
        Sum1(Num+1,Mc) = 1;
    end
    %------------------------------------------------
    %Swerling 2
    A2(Num+1,:) = sqrt(((sqrt(1/2)*sigs1*randn(1,Np)).^2)+((sqrt(1/2)*sigs1*randn(1,Np)).^2));
    S2(Num+1,:) = A2(Num+1,:).*exp(1i*2*pi*rand(1,Np));
    X2(Num+1,:) = abs(awgn(S2(Num+1,:),SNR,'measured')).^2;
    X2sum(Num+1,Mc) = sum(X2(Num+1,:));
    if X2sum(Num+1,Mc) >= Vt
        Sum2(Num+1,Mc) = 1;
    end
    %-------------------------------------------------
    %Swerling 3
    A3(Num+1,1) =  sqrt(((0.5*sigs1*randn(1))^2)+((0.5*sigs1*randn(1))^2)+((0.5*sigs1*randn(1))^2)+((0.5*sigs1*randn(1))^2));
    S3(Num+1,:) =  A3(Num+1,1)*exp(1i*2*pi*rand(1,10));
    X3(Num+1,:) = abs(awgn(S3(Num+1,:),SNR,'measured')).^2;
    X3sum(Num+1,:) = sum(X3(Num+1,:));
    if X3sum(Num+1,:) >= Vt 
        Sum3(Num+1,Mc) = 1;
    end
    %--------------------------------------------------
    %Swerling 4
    A4(Num+1,:) = sqrt(((0.5*sigs1*randn(1,Np)).^2)+((0.5*sigs1*randn(1,Np)).^2)+((0.5*sigs1*randn(1,Np)).^2)+((0.5*sigs1*randn(1,Np)).^2));
    S4(Num+1,:) = A4(Num+1,:).*exp(1i*2*pi*rand(1,Np));
    X4(Num+1,:) = abs(awgn(S4(Num+1,:),SNR,'measured')).^2;
    X4sum(Num+1,Mc) = sum(X4(Num+1,:));
    if X4sum(Num+1,Mc) >= Vt
        Sum4(Num+1,Mc) = 1;
    end
end
end
for i =0:20
Pd0(i+1,:) = sum(Sum0(i+1,:))./(Mc-1);
Pd1(i+1,:) = sum(Sum1(i+1,:))./(Mc-1);
Pd2(i+1,:) = sum(Sum2(i+1,:))./(Mc-1);
Pd3(i+1,:) = sum(Sum3(i+1,:))./(Mc-1);
Pd4(i+1,:) = sum(Sum4(i+1,:))./(Mc-1);
end
%profile view
xx=-10:1:10;
figure(1)
plot((-10:10),Pd0);
xlabel('SNR/dB');
ylabel('Pd');
title('Swerling 0');

figure(2)
plot((-10:10),Pd1);
xlabel('SNR/dB');
ylabel('Pd');
title('Swerling 1');

figure(3)
plot((-10:10),Pd2);
xlabel('SNR/dB');
ylabel('Pd');
title('Swerling 2');

figure(4)
plot((-10:10),Pd3);
xlabel('SNR/dB');
ylabel('Pd');
title('Swerling 3');

figure(5)
plot((-10:10),Pd4);
xlabel('SNR/dB');
ylabel('Pd');
title('Swerling 4');

figure(6)
hold on

plot(xx,Pd1,'b*',xx,Pd2,'b-',xx,Pd3,'b--',xx,Pd0,'b:',xx,Pd4,'b-.');

legend('Swerling 1','Swerling 2','Swerling3','Swerling 0','Swerling 4')
```

# 参考文献

[1]	杨瀚涛.网络协同雷达对Swerling型目标的检测研究[J].国外电子测量技术,2017,36(05):107-110.
[2]	徐喜安. 单脉冲雷达系统的建模与仿真研究[D].电子科技大学,2006.
[3]	李皓. 基于单脉冲雷达的多目标检测方法与仿真[D].北京理工大学,2016.
[4]	丁鹭飞. 雷达原理.电子工业出版社.2009,3.
[5]	楼顺天. 基于MATLAB的系统分析与设计——信号处理.西安电子科技大学出版社.1998,9.
[6]	MATLAB Simulations for Radar Systems Design.2004


***

EOF