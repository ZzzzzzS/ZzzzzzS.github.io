---
title: kinetis KV58 DMA模块食用指南
date: 2018-01-30 14:12:32
tags: [ARM,kinetis,register]
author: 
 nick: ZZS
 link: http://zzzzzzs.github.io/
cover: http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%89999%E5%9B%BE.png
---

# NXP Kinetis系列 KV58微控制器DMA模块食用指南

> 本文主要以KV58为例介绍kinetis系列微控制器的DMA模块的寄存器以及配置方法.

# DMA是什么
 DMA全称直接内存访问(Direct Memory Access).是所有现代电脑的重要特色，它允许不同速度的硬件装置来沟通,而不需要依赖于 CPU 的大量中断负载.工作过程中不需要CPU干预,也不需要像中断处理方式那样需要保留现场,恢复现场之类的麻烦事,简单理解为一条直接连通外设与RAM的硬件通道,所以DMA技术可以提高系统运行效率（即CPU可以干其他的事去,算是一种简单的并行模式吧）.关于更多DMA的说明这里就不再多说,可以参考参考百度百科的说明[https://baike.baidu.com/item/DMA/2385376?fr=aladdin](https://baike.baidu.com/item/DMA/2385376?fr=aladdin)

 # Kinetis的DMA
对于kinetis来说,DMA主要分为两大模块
* **DMAMUX**    直接内存访问多路复用器(Direct Memory Access Multiplexer)
* **eDMA** 直接内存访问控制器(Enhanced Direct Memory Access)

DMAMUX实质上是一个矩阵开关,负责将DMA的触发源映射到对应的DMA通道中.而eDMA才是真正搬运数据的模块,可以看到,kinetis的DMA前多了个**e**,代表Enhanced增强型.从这里也可以看出kinetis系列DMA的强大和灵活了.eDMA模块下又主要分为了两大部分: TCD传输控制器(Transfer Control Descriptor)用于控制每个通道的传输情况以及DMA引擎(eDMA engine)用于控制整个DMA引擎的状态,如下图所示 ([摘自**KV5x Sub-Family Reference Manual** Page 486
](https://www.nxp.com/docs/en/reference-manual/KV5XP144M240RM.pdf)):

![](http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%89%E5%9B%BE.png)

DMA是如何搬运数据的可以用一下流程图来描述:

![](http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/6374029876143.jpg)

如图所示,DMA触发源先经过DMAMUX将源分配到不同的DMA通道上,不同的DMA通道根据TCD寄存器的配置来将数据从源地址搬运到目标地址.那么这样来看,配置寄存器主要就分为以下几个步骤:
* 打开有关的时钟(DMAMUX,eDMA,其他用到的模块如SPI的时钟)
* 配置DMAMUX触发源
* 配置eDMA引擎相关寄存器
* 配置TCD传输相关寄存器
* 打开相关外设的DMA使能
* 打开DMA中断等,开始DMA传输

# DMAMUX模块
前面说到DMAMUX是配置触发源到DMA通道,KV58微控制器有64个触发源,32个DMA通道.64个触发源如下(摘自CMSIS MKV58F24.h):
## DMAMUX触发源
```c
typedef enum _dma_request_source
{
    kDmaRequestMux0Disable          = 0|0x100U,    /**< DMAMUX TriggerDisabled. */
    kDmaRequestMux0Reserved1        = 1|0x100U,    /**< Reserved1 */
    kDmaRequestMux0UART0Rx          = 2|0x100U,    /**< UART0 Receive. */
    kDmaRequestMux0UART0Tx          = 3|0x100U,    /**< UART0 Transmit. */
    kDmaRequestMux0UART1Rx          = 4|0x100U,    /**< UART1 Receive. */
    kDmaRequestMux0UART1Tx          = 5|0x100U,    /**< UART1 Transmit. */
    kDmaRequestMux0PWM0WR0          = 6|0x100U,    /**< PWM0 Write Request 0. */
    kDmaRequestMux0PWM0WR1          = 7|0x100U,    /**< PWM0 Write Request 1. */
    kDmaRequestMux0PWM0WR2          = 8|0x100U,    /**< PWM0 Write Request 2. */
    kDmaRequestMux0PWM0WR3          = 9|0x100U,    /**< PWM0 Write Request 3. */
    kDmaRequestMux0PWM0CP0          = 10|0x100U,   /**< PWM0 Capture 0. */
    kDmaRequestMux0PWM0CP1          = 11|0x100U,   /**< PWM0 Capture 1. */
    kDmaRequestMux0PWM0CP2          = 12|0x100U,   /**< PWM0 Capture 2. */
    kDmaRequestMux0PWM0CP3          = 13|0x100U,   /**< PWM0 Capture 3. */
    kDmaRequestMux0CAN0             = 14|0x100U,   /**< CAN0. */
    kDmaRequestMux0CAN1             = 15|0x100U,   /**< CAN1. */
    kDmaRequestMux0SPI0Rx           = 16|0x100U,   /**< SPI0 Receive. */
    kDmaRequestMux0SPI0Tx           = 17|0x100U,   /**< SPI0 Transmit. */
    kDmaRequestMux0XBARAOUT0        = 18|0x100U,   /**< XBARA Output 0. */
    kDmaRequestMux0XBARAOUT1        = 19|0x100U,   /**< XBARA Output 1. */
    kDmaRequestMux0XBARAOUT2        = 20|0x100U,   /**< XBARA Output 2. */
    kDmaRequestMux0XBARAOUT3        = 21|0x100U,   /**< XBARA Output 3. */
    kDmaRequestMux0I2C0             = 22|0x100U,   /**< I2C0. */
    kDmaRequestMux0Reserved23       = 23|0x100U,   /**< Reserved23 */
    kDmaRequestMux0FTM0Channel0     = 24|0x100U,   /**< FTM0 C0V. */
    kDmaRequestMux0FTM0Channel1     = 25|0x100U,   /**< FTM0 C1V. */
    kDmaRequestMux0FTM0Channel2     = 26|0x100U,   /**< FTM0 C2V. */
    kDmaRequestMux0FTM0Channel3     = 27|0x100U,   /**< FTM0 C3V. */
    kDmaRequestMux0FTM0Channel4     = 28|0x100U,   /**< FTM0 C4V. */
    kDmaRequestMux0FTM0Channel5     = 29|0x100U,   /**< FTM0 C5V. */
    kDmaRequestMux0FTM0Channel6     = 30|0x100U,   /**< FTM0 C6V. */
    kDmaRequestMux0FTM0Channel7     = 31|0x100U,   /**< FTM0 C7V. */
    kDmaRequestMux0FTM1Channel0     = 32|0x100U,   /**< FTM1 C0V. */
    kDmaRequestMux0FTM1Channel1     = 33|0x100U,   /**< FTM1 C1V. */
    kDmaRequestMux0CMP3             = 34|0x100U,   /**< CMP3. */
    kDmaRequestMux0Reserved35       = 35|0x100U,   /**< Reserved35 */
    kDmaRequestMux0FTM3Channel0     = 36|0x100U,   /**< FTM3 C0V. */
    kDmaRequestMux0FTM3Channel1     = 37|0x100U,   /**< FTM3 C1V. */
    kDmaRequestMux0FTM3Channel2     = 38|0x100U,   /**< FTM3 C2V. */
    kDmaRequestMux0FTM3Channel3     = 39|0x100U,   /**< FTM3 C3V. */
    kDmaRequestMux0HSADC0A          = 40|0x100U,   /**< HSADC0. */
    kDmaRequestMux0HSADC0B          = 41|0x100U,   /**< HSADC0. */
    kDmaRequestMux0CMP0             = 42|0x100U,   /**< CMP0. */
    kDmaRequestMux0CMP1             = 43|0x100U,   /**< CMP1. */
    kDmaRequestMux0CMP2             = 44|0x100U,   /**< CMP2. */
    kDmaRequestMux0DAC0             = 45|0x100U,   /**< DAC0. */
    kDmaRequestMux0Reserved46       = 46|0x100U,   /**< Reserved46 */
    kDmaRequestMux0PDB1             = 47|0x100U,   /**< PDB1. */
    kDmaRequestMux0PDB0             = 48|0x100U,   /**< PDB0. */
    kDmaRequestMux0PortA            = 49|0x100U,   /**< PTA. */
    kDmaRequestMux0PortB            = 50|0x100U,   /**< PTB. */
    kDmaRequestMux0PortC            = 51|0x100U,   /**< PTC. */
    kDmaRequestMux0PortD            = 52|0x100U,   /**< PTD. */
    kDmaRequestMux0PortE            = 53|0x100U,   /**< PTE. */
    kDmaRequestMux0FTM3Channel4     = 54|0x100U,   /**< FTM3 C4V. */
    kDmaRequestMux0FTM3Channel5     = 55|0x100U,   /**< FTM3 C5V. */
    kDmaRequestMux0FTM3Channel6     = 56|0x100U,   /**< FTM3 C6V. */
    kDmaRequestMux0FTM3Channel7     = 57|0x100U,   /**< FTM3 C7V. */
    kDmaRequestMux0Reserved58       = 58|0x100U,   /**< Reserved58 */
    kDmaRequestMux0Reserved59       = 59|0x100U,   /**< Reserved59 */
    kDmaRequestMux0AlwaysOn60       = 60|0x100U,   /**< DMAMUX Always Enabled slot. */
    kDmaRequestMux0AlwaysOn61       = 61|0x100U,   /**< DMAMUX Always Enabled slot. */
    kDmaRequestMux0AlwaysOn62       = 62|0x100U,   /**< DMAMUX Always Enabled slot. */
    kDmaRequestMux0AlwaysOn63       = 63|0x100U,   /**< DMAMUX Always Enabled slot. */
    kDmaRequestMux0Group1Disable    = 0|0x200U,    /**< DMAMUX TriggerDisabled. */
    kDmaRequestMux0Group1Reserved1  = 1|0x200U,    /**< Reserved1 */
    kDmaRequestMux0Group1UART2Rx    = 2|0x200U,    /**< UART2 Receive. */
    kDmaRequestMux0Group1UART2Tx    = 3|0x200U,    /**< UART2 Transmit. */
    kDmaRequestMux0Group1UART3Rx    = 4|0x200U,    /**< UART3 Receive. */
    kDmaRequestMux0Group1UART3Tx    = 5|0x200U,    /**< UART3 Transmit. */
    kDmaRequestMux0Group1PWM1WR0    = 6|0x200U,    /**< PWM1 Write Request 0. */
    kDmaRequestMux0Group1PWM1WR1    = 7|0x200U,    /**< PWM1 Write Request 1. */
    kDmaRequestMux0Group1PWM1WR2    = 8|0x200U,    /**< PWM1 Write Request 2. */
    kDmaRequestMux0Group1PWM1WR3    = 9|0x200U,    /**< PWM1 Write Request 3. */
    kDmaRequestMux0Group1PWM1CP0    = 10|0x200U,   /**< PWM1 Capture 0. */
    kDmaRequestMux0Group1PWM1CP1    = 11|0x200U,   /**< PWM1 Capture 1. */
    kDmaRequestMux0Group1PWM1CP2    = 12|0x200U,   /**< PWM1 Capture 2. */
    kDmaRequestMux0Group1PWM1CP3    = 13|0x200U,   /**< PWM1 Capture 3. */
    kDmaRequestMux0Group1CAN2       = 14|0x200U,   /**< CAN2. */
    kDmaRequestMux0Group1Reserved15 = 15|0x200U,   /**< Reserved15 */
    kDmaRequestMux0Group1SPI1Rx     = 16|0x200U,   /**< SPI1 Receive. */
    kDmaRequestMux0Group1SPI1Tx     = 17|0x200U,   /**< SPI1 Transmit. */
    kDmaRequestMux0Group1Reserved18 = 18|0x200U,   /**< Reserved18 */
    kDmaRequestMux0Group1Reserved19 = 19|0x200U,   /**< Reserved19 */
    kDmaRequestMux0Group1Reserved20 = 20|0x200U,   /**< Reserved20 */
    kDmaRequestMux0Group1Reserved21 = 21|0x200U,   /**< Reserved21 */
    kDmaRequestMux0Group1I2C1       = 22|0x200U,   /**< I2C1. */
    kDmaRequestMux0Group1Reserved23 = 23|0x200U,   /**< Reserved23 */
    kDmaRequestMux0Group1Reserved24 = 24|0x200U,   /**< Reserved24 */
    kDmaRequestMux0Group1Reserved25 = 25|0x200U,   /**< Reserved25 */
    kDmaRequestMux0Group1Reserved26 = 26|0x200U,   /**< Reserved26 */
    kDmaRequestMux0Group1Reserved27 = 27|0x200U,   /**< Reserved27 */
    kDmaRequestMux0Group1Reserved28 = 28|0x200U,   /**< Reserved28 */
    kDmaRequestMux0Group1Reserved29 = 29|0x200U,   /**< Reserved29 */
    kDmaRequestMux0Group1Reserved30 = 30|0x200U,   /**< Reserved30 */
    kDmaRequestMux0Group1Reserved31 = 31|0x200U,   /**< Reserved31 */
    kDmaRequestMux0Group1FTM2Channel0 = 32|0x200U, /**< FTM2 C0V. */
    kDmaRequestMux0Group1FTM2Channel1 = 33|0x200U, /**< FTM2 C1V. */
    kDmaRequestMux0Group1SPI2Rx     = 34|0x200U,   /**< SPI2 Receive. */
    kDmaRequestMux0Group1SPI2Tx     = 35|0x200U,   /**< SPI2 Transmit. */
    kDmaRequestMux0Group1IEEE1588Timer0 = 36|0x200U, /**< ENET IEEE 1588 timer 0. */
    kDmaRequestMux0Group1IEEE1588Timer1 = 37|0x200U, /**< ENET IEEE 1588 timer 1. */
    kDmaRequestMux0Group1IEEE1588Timer2 = 38|0x200U, /**< ENET IEEE 1588 timer 2. */
    kDmaRequestMux0Group1IEEE1588Timer3 = 39|0x200U, /**< ENET IEEE 1588 timer 3. */
    kDmaRequestMux0Group1HSADC1A    = 40|0x200U,   /**< HSADC1. */
    kDmaRequestMux0Group1HSADC1B    = 41|0x200U,   /**< HSADC1. */
    kDmaRequestMux0Group1Reserved42 = 42|0x200U,   /**< Reserved42 */
    kDmaRequestMux0Group1Reserved43 = 43|0x200U,   /**< Reserved43 */
    kDmaRequestMux0Group1Reserved44 = 44|0x200U,   /**< Reserved44 */
    kDmaRequestMux0Group1ADC0       = 45|0x200U,   /**< ADC0. */
    kDmaRequestMux0Group1Reserved46 = 46|0x200U,   /**< Reserved46 */
    kDmaRequestMux0Group1Reserved47 = 47|0x200U,   /**< Reserved47 */
    kDmaRequestMux0Group1Reserved48 = 48|0x200U,   /**< Reserved48 */
    kDmaRequestMux0Group1Reserved49 = 49|0x200U,   /**< Reserved49 */
    kDmaRequestMux0Group1Reserved50 = 50|0x200U,   /**< Reserved50 */
    kDmaRequestMux0Group1Reserved51 = 51|0x200U,   /**< Reserved51 */
    kDmaRequestMux0Group1Reserved52 = 52|0x200U,   /**< Reserved52 */
    kDmaRequestMux0Group1Reserved53 = 53|0x200U,   /**< Reserved53 */
    kDmaRequestMux0Group1UART4Rx    = 54|0x200U,   /**< UART4 Receive. */
    kDmaRequestMux0Group1UART4Tx    = 55|0x200U,   /**< UART4 Transmit. */
    kDmaRequestMux0Group1UART5Rx    = 56|0x200U,   /**< UART5 Receive. */
    kDmaRequestMux0Group1UART5Tx    = 57|0x200U,   /**< UART5 Transmit. */
    kDmaRequestMux0Group1Reserved58 = 58|0x200U,   /**< Reserved58 */
    kDmaRequestMux0Group1Reserved59 = 59|0x200U,   /**< Reserved59 */
    kDmaRequestMux0Group1AlwaysOn60 = 60|0x200U,   /**< DMAMUX Always Enabled slot. */
    kDmaRequestMux0Group1AlwaysOn61 = 61|0x200U,   /**< DMAMUX Always Enabled slot. */
    kDmaRequestMux0Group1AlwaysOn62 = 62|0x200U,   /**< DMAMUX Always Enabled slot. */
    kDmaRequestMux0Group1AlwaysOn63 = 63|0x200U,   /**< DMAMUX Always Enabled slot. */
} dma_request_source_t;
```

我们可以看到,触发源已经涵盖了大部分外设,需要注意的是60~63号触发源,这几个是常开触发源,主要可以用于需要一直触发快速搬运的地方或者是从内存搬运到内存的情况,官方解释如下(([摘自**KV5x Sub-Family Reference Manual** Page 480
](https://www.nxp.com/docs/en/reference-manual/KV5XP144M240RM.pdf))):
> ## 25.5.3 Always-enabled DMA sources
>In addition to the peripherals that can be used as DMA sources, there are four additional DMA sources that are always enabled. Unlike the peripheral DMA sources, where the peripheral controls the flow of data during DMA transfers, the sources that are always enabled provide no such "throttling" of the data transfers. These sources are most useful in the following cases:
>* Performing DMA transfers to/from GPIO—Moving data from/to one or more GPIO pins, either unthrottled (that is, as fast as possible), or periodically (using the DMA triggering capability). 
>* Performing DMA transfers from memory to memory—Moving data from memory to memory, typically as fast as possible, sometimes with software activation.
>* Performing DMA transfers from memory to the external bus, or vice-versa—Similar to memory to memory transfers, this is typically done as quickly as possible.
>* Any DMA transfer that requires software activation—Any DMA transfer that should be explicitly started by software.

## DMAMUX寄存器
寄存器定义在MKV58F24.h中定义如下:

```c
/* ----------------------------------------------------------------------------
   -- DMAMUX Peripheral Access Layer
   ---------------------------------------------------------------------------- */

/*!
 * @addtogroup DMAMUX_Peripheral_Access_Layer DMAMUX Peripheral Access Layer
 * @{
 */

/** DMAMUX - Register Layout Typedef */
typedef struct {
  __IO uint8_t CHCFG[32];                          /**< Channel Configuration register, array offset: 0x0, array step: 0x1 */
} DMAMUX_Type;
```


![](
http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%892%E5%9B%BE.png)

(([摘自**KV5x Sub-Family Reference Manual** Page 477
](https://www.nxp.com/docs/en/reference-manual/KV5XP144M240RM.pdf)))

可以看到非常的简单,每一个8位寄存器对应着每一个DMA通道.
ENBL用于开启相应的复用开关,SOURCE对应着前面枚举的64个DMA触发源.有点特殊的是TRIG,这个可以使用PIT定时器周期性触发DMA,不过只有前4个DMA通道支持该功能,关于详细的部分可以在PIT定时器的相关章节找到.

## DMAMUX配置顺序
* 清空寄存器
* 选择相关的复用通道配置需要的触发源
* 选择是否需要周期触发功能
* 打开该复用通道

以下是官方的解释(([摘自**KV5x Sub-Family Reference Manual** Page 481
](https://www.nxp.com/docs/en/reference-manual/KV5XP144M240RM.pdf))):

>* Determine with which DMA channel the source will be associated. Note that only the first 4 DMA channels have periodic triggering capability.
>*  Clear the CHCFG[ENBL] and CHCFG[TRIG] fields of the DMA channel.
>*  Ensure that the DMA channel is properly configured in the DMA. The DMA channel may be enabled at this point. 
>*  Configure the corresponding timer. 
>*  Select the source to be routed to the DMA channel. Write to the corresponding CHCFG register, ensuring that the CHCFG[ENBL] and CHCFG[TRIG] fields are set. 

## DMAMUX配置实例
以下是一个DMAMUX配置的例子

```c
SIM->SCGC6 |= SIM_SCGC6_DMAMUX_MASK; //打开DMAMUX时钟
DMAMUX->CHCFG[0] = 0; //清空寄存器通道0
DMAMUX->CHCFG[0] |= DMAMUX_CHCFG_SOURCE(kDmaRequestMux0AlwaysOn63);//配置63号源到通道0
DMAMUX->CHCFG[0] |= DMAMUX_CHCFG_ENBL_MASK;//使能通道
```

# eDMA模块
接下来才是重头戏,eDMA模块.
## eDMA 特性
下面介绍下Kinetis的eDMA的一些特性，有点多，就挑重点和特色的来说了：
* 16个独立可配置的DMA通道，其中前四个通道可配置成周期性触发(需要用到PIT模块).
* 52个外设触发slots(这个我担心翻译不好误人子弟了就直接用该单词替代了,用过Qt的人都这是个槽的概念,大家权当触发源来理解吧),10个直通slots,每一个slot可以通过软件编程路由到16个DMA通道中的任意一个(这个通过配置DMAMUX_CONFIGn得到).
* 独立可编程的源地址、目标地址和传输宽度(8bit,16bit,32bit,另外支持16byte的缓存),支持外设到RAM,RAM到外设,RAM到RAM之间的传输.
*　每一个通道都有一个11个寄存器的TCD（Tranfer control descripter），注意这11个寄存器（包括16位和32位宽度的寄存器）才是我们编写驱动的重点对象．
* 固定的优先级模式和时间轮询（round-robin）优先级模式（注意：如果不通过软件设置优先级的话，系统默认为每个通道的优先级等于它的通道号，即0通道的优先级为0，且优先级号越小，其优先级越低）
* 每个通道包括了三个中断标志，即DMA半传输完成标志、DMA传输完成标志和DMA传输出错标志，3个标志逻辑或成一个中断请求（所以如果都使能了，那可以通过查询相关标志寄存器来判断当前的中断类型）.
* 可软件中断取消DMA传输（通过配置DMA_CR_CX位）.

以下是官方的解释(([摘自**KV5x Sub-Family Reference Manual** Page 487
](https://www.nxp.com/docs/en/reference-manual/KV5XP144M240RM.pdf))):

>## 26.1.3 Features 
>The eDMA is a highly programmable data-transfer engine optimized to minimize any required intervention from the host processor. It is intended for use in applications where the data size to be transferred is statically known and not defined within the transferred data itself. The eDMA module features:
>* All data movement via dual-address transfers: read from source, write to destination
>* Programmable source and destination addresses and transfer size 
>*Support for enhanced addressing modes
>* 32-channel implementation that performs complex data transfers with minimal intervention from a host processor 
>*　Internal data buffer, used as temporary storage to support 16- and 32-byte transfers 
>* Connections to the crossbar switch for bus mastering the data movement 
>* Transfer control descriptor (TCD) organized to support two-deep, nested transfer operations 
>* 32-byte TCD stored in local memory for each channel 
>* An inner data transfer loop defined by a minor byte transfer count 
>*An outer data transfer loop defined by a major iteration count 
>* Channel activation via one of three methods: 
>* Explicit software initiation 
>* Initiation via a channel-to-channel linking mechanism for continuous transfers 
>* Peripheral-paced hardware requests, one per channel 
>* Fixed-priority and round-robin channel arbitration 
>* Channel completion reported via programmable interrupt requests 
>* One interrupt per channel, which can be asserted at completion of major iteration count 
>* Programmable error terminations per channel and logically summed together to form one error interrupt to the interrupt controller 
>* Programmable support for scatter/gather DMA processing 
>* Support for complex data structures  

>In the discussion of this module, n is used to reference the channel number.

## eDMA channel分组:
KV58中DMA通道分为两组
* group0 0~15通道
* group1 16~31通道
不同通道需要设置成不同的权值,这是非常容易忽略的地方.

## 主循环和附循环
数据的传送分为主循环 （ major loop ） 和副循环 （ minor loop ）. 如何理解这两个概念呢。 我们不妨假设用软件来实现有规律的顺序数据传送，使用 C 语言来实现的话，可以用 for 循 环。好比用两层嵌套的 for 循环来实现。如使用 DMA 做同样的工作，过程是相同的，外层 的循环又称主循环，即 major loop 。内层循环称为副循环，即 minor loop 。 major loop 循环 一次，可能需要 minor loop 循环多次。每个 minor loop 循环都需要 DMA 源发来请求或者通 过软件请求。 每个 minor loop 传送完毕， 对应的 DMA 通道就进入空闲模式， 等待下一次 DMA 请求。当所有 DMA 传送完毕，即置 DONE 标志，并且可以通过设置选择传送完毕是否触发 中断。
  

## eDMA寄存器介绍
以下是eDMA模块寄存器表(摘自MKV58F24.h):
```c

/* ----------------------------------------------------------------------------
   -- DMA Peripheral Access Layer
   ---------------------------------------------------------------------------- */

/*!
 * @addtogroup DMA_Peripheral_Access_Layer DMA Peripheral Access Layer
 * @{
 */

/** DMA - Register Layout Typedef */
typedef struct {
  __IO uint32_t CR;                                /**< Control Register, offset: 0x0 */
  __I  uint32_t ES;                                /**< Error Status Register, offset: 0x4 */
       uint8_t RESERVED_0[4];
  __IO uint32_t ERQ;                               /**< Enable Request Register, offset: 0xC */
       uint8_t RESERVED_1[4];
  __IO uint32_t EEI;                               /**< Enable Error Interrupt Register, offset: 0x14 */
  __O  uint8_t CEEI;                               /**< Clear Enable Error Interrupt Register, offset: 0x18 */
  __O  uint8_t SEEI;                               /**< Set Enable Error Interrupt Register, offset: 0x19 */
  __O  uint8_t CERQ;                               /**< Clear Enable Request Register, offset: 0x1A */
  __O  uint8_t SERQ;                               /**< Set Enable Request Register, offset: 0x1B */
  __O  uint8_t CDNE;                               /**< Clear DONE Status Bit Register, offset: 0x1C */
  __O  uint8_t SSRT;                               /**< Set START Bit Register, offset: 0x1D */
  __O  uint8_t CERR;                               /**< Clear Error Register, offset: 0x1E */
  __O  uint8_t CINT;                               /**< Clear Interrupt Request Register, offset: 0x1F */
       uint8_t RESERVED_2[4];
  __IO uint32_t INT;                               /**< Interrupt Request Register, offset: 0x24 */
       uint8_t RESERVED_3[4];
  __IO uint32_t ERR;                               /**< Error Register, offset: 0x2C */
       uint8_t RESERVED_4[4];
  __I  uint32_t HRS;                               /**< Hardware Request Status Register, offset: 0x34 */
       uint8_t RESERVED_5[12];
  __IO uint32_t EARS;                              /**< Enable Asynchronous Request in Stop Register, offset: 0x44 */
       uint8_t RESERVED_6[184];
  __IO uint8_t DCHPRI3;                            /**< Channel n Priority Register, offset: 0x100 */
  __IO uint8_t DCHPRI2;                            /**< Channel n Priority Register, offset: 0x101 */
  __IO uint8_t DCHPRI1;                            /**< Channel n Priority Register, offset: 0x102 */
  __IO uint8_t DCHPRI0;                            /**< Channel n Priority Register, offset: 0x103 */
  __IO uint8_t DCHPRI7;                            /**< Channel n Priority Register, offset: 0x104 */
  __IO uint8_t DCHPRI6;                            /**< Channel n Priority Register, offset: 0x105 */
  __IO uint8_t DCHPRI5;                            /**< Channel n Priority Register, offset: 0x106 */
  __IO uint8_t DCHPRI4;                            /**< Channel n Priority Register, offset: 0x107 */
  __IO uint8_t DCHPRI11;                           /**< Channel n Priority Register, offset: 0x108 */
  __IO uint8_t DCHPRI10;                           /**< Channel n Priority Register, offset: 0x109 */
  __IO uint8_t DCHPRI9;                            /**< Channel n Priority Register, offset: 0x10A */
  __IO uint8_t DCHPRI8;                            /**< Channel n Priority Register, offset: 0x10B */
  __IO uint8_t DCHPRI15;                           /**< Channel n Priority Register, offset: 0x10C */
  __IO uint8_t DCHPRI14;                           /**< Channel n Priority Register, offset: 0x10D */
  __IO uint8_t DCHPRI13;                           /**< Channel n Priority Register, offset: 0x10E */
  __IO uint8_t DCHPRI12;                           /**< Channel n Priority Register, offset: 0x10F */
  __IO uint8_t DCHPRI19;                           /**< Channel n Priority Register, offset: 0x110 */
  __IO uint8_t DCHPRI18;                           /**< Channel n Priority Register, offset: 0x111 */
  __IO uint8_t DCHPRI17;                           /**< Channel n Priority Register, offset: 0x112 */
  __IO uint8_t DCHPRI16;                           /**< Channel n Priority Register, offset: 0x113 */
  __IO uint8_t DCHPRI23;                           /**< Channel n Priority Register, offset: 0x114 */
  __IO uint8_t DCHPRI22;                           /**< Channel n Priority Register, offset: 0x115 */
  __IO uint8_t DCHPRI21;                           /**< Channel n Priority Register, offset: 0x116 */
  __IO uint8_t DCHPRI20;                           /**< Channel n Priority Register, offset: 0x117 */
  __IO uint8_t DCHPRI27;                           /**< Channel n Priority Register, offset: 0x118 */
  __IO uint8_t DCHPRI26;                           /**< Channel n Priority Register, offset: 0x119 */
  __IO uint8_t DCHPRI25;                           /**< Channel n Priority Register, offset: 0x11A */
  __IO uint8_t DCHPRI24;                           /**< Channel n Priority Register, offset: 0x11B */
  __IO uint8_t DCHPRI31;                           /**< Channel n Priority Register, offset: 0x11C */
  __IO uint8_t DCHPRI30;                           /**< Channel n Priority Register, offset: 0x11D */
  __IO uint8_t DCHPRI29;                           /**< Channel n Priority Register, offset: 0x11E */
  __IO uint8_t DCHPRI28;                           /**< Channel n Priority Register, offset: 0x11F */
       uint8_t RESERVED_7[3808];
  struct {                                         /* offset: 0x1000, array step: 0x20 */
    __IO uint32_t SADDR;                             /**< TCD Source Address, array offset: 0x1000, array step: 0x20 */
    __IO uint16_t SOFF;                              /**< TCD Signed Source Address Offset, array offset: 0x1004, array step: 0x20 */
    __IO uint16_t ATTR;                              /**< TCD Transfer Attributes, array offset: 0x1006, array step: 0x20 */
    union {                                          /* offset: 0x1008, array step: 0x20 */
      __IO uint32_t NBYTES_MLNO;                       /**< TCD Minor Byte Count (Minor Loop Mapping Disabled), array offset: 0x1008, array step: 0x20 */
      __IO uint32_t NBYTES_MLOFFNO;                    /**< TCD Signed Minor Loop Offset (Minor Loop Mapping Enabled and Offset Disabled), array offset: 0x1008, array step: 0x20 */
      __IO uint32_t NBYTES_MLOFFYES;                   /**< TCD Signed Minor Loop Offset (Minor Loop Mapping and Offset Enabled), array offset: 0x1008, array step: 0x20 */
    };
    __IO uint32_t SLAST;                             /**< TCD Last Source Address Adjustment, array offset: 0x100C, array step: 0x20 */
    __IO uint32_t DADDR;                             /**< TCD Destination Address, array offset: 0x1010, array step: 0x20 */
    __IO uint16_t DOFF;                              /**< TCD Signed Destination Address Offset, array offset: 0x1014, array step: 0x20 */
    union {                                          /* offset: 0x1016, array step: 0x20 */
      __IO uint16_t CITER_ELINKNO;                     /**< TCD Current Minor Loop Link, Major Loop Count (Channel Linking Disabled), array offset: 0x1016, array step: 0x20 */
      __IO uint16_t CITER_ELINKYES;                    /**< TCD Current Minor Loop Link, Major Loop Count (Channel Linking Enabled), array offset: 0x1016, array step: 0x20 */
    };
    __IO uint32_t DLAST_SGA;                         /**< TCD Last Destination Address Adjustment/Scatter Gather Address, array offset: 0x1018, array step: 0x20 */
    __IO uint16_t CSR;                               /**< TCD Control and Status, array offset: 0x101C, array step: 0x20 */
    union {                                          /* offset: 0x101E, array step: 0x20 */
      __IO uint16_t BITER_ELINKNO;                     /**< TCD Beginning Minor Loop Link, Major Loop Count (Channel Linking Disabled), array offset: 0x101E, array step: 0x20 */
      __IO uint16_t BITER_ELINKYES;                    /**< TCD Beginning Minor Loop Link, Major Loop Count (Channel Linking Enabled), array offset: 0x101E, array step: 0x20 */
    };
  } TCD[32];
} DMA_Type;
```
### 首先介绍非常重要的TCD传输控制块寄存器
以下是TCD控制块的寄存器分布(([摘自**KV5x Sub-Family Reference Manual** Page 489
](https://www.nxp.com/docs/en/reference-manual/KV5XP144M240RM.pdf))):

![](
http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%89%E5%9B%BE2.png)

#### TCD Source Address (DMA_TCDn_SADDR)
存放需要搬运的数据的源地址
#### TCD Signed Source Address Offset (DMA_TCDn_SOFF)
源地址传输一个数据之后的偏移量
(Sign-extended offset applied to the current source address to form the next-state value as each source read is completed.)

#### TCD Transfer Attributes (DMA_TCDn_ATTR)
![](
http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%8922%E5%9B%BE.png)

主要说其中的SSIZE和DSIZE,分别表示每一次传输的源数据宽度和目的数据宽度
其中000表示8bit, 001表示16bit, 010表示32bit.

####  TCD Minor Byte Count (Minor Loop Mapping Disabled) (DMA_TCDn_NBYTES_MLNO)
仅介绍这一种情况,即附循环映射被禁止的情况,寄存器的值表示一次附循环搬移的数据大小,如果为0则表示搬运4GB.

#### TCD Last Source Address Adjustment (DMA_TCDn_SLAST)
该寄存器控制当主循环结束后源地址的偏移情况,寄存器值可为正或负,0表示不偏移.

#### TCD Destination Address (DMA_TCDn_DADDR)
储存目标地址

####  TCD Signed Destination Address Offset (DMA_TCDn_DOFF)
目标地址传输一个数据之后的偏移量

#### TCD Current Minor Loop Link, Major Loop Count (Channel Linking Disabled) (DMA_TCDn_CITER_ELINKNO)
仅介绍这一种情况,也就是通道之间的联系被禁止的情况.该寄存器用于表示主循环的次数.

#### TCD Beginning Minor Loop Link, Major Loop Count (Channel Linking Disabled) (DMA_TCDn_BITER_ELINKNO)
仅介绍这一种情况,该寄存器应与``CITER``寄存器配置成相同的值

#### TCD Last Destination Address Adjustment/Scatter Gather Address (DMA_TCDn_DLASTSGA)
该寄存器控制当主循环结束后目标地址的偏移情况,寄存器值可为正或负,0表示不偏移.

#### TCD Control and Status (DMA_TCDn_CSR)

![](http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%89%E5%9B%BE4.png)

INTMAJOR: 允许中断
START:软件触发传输

## eDMA引擎寄存器

#### Control Register (DMA_CR)

![](http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%89111%E5%9B%BE.png)

最需要注意的就是``GRP1PRI``和``GRP0PRI``需要设置成不同的权值

#### Error Status Register (DMA_ES)
各种错误标志位寄存器

#### Enable Request Register (DMA_ERQ)
允许传输寄存器

![](http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%891234%E5%9B%BE.png)

#### Channel n Priority Register (DMA_DCHPRIn)
优先级分组寄存器,0是最低优先级.

# DMA模块初始化过程
* 配置CR寄存器
* 配置通道优先级
* 配置TCD传输控制块
* 使能传输控制
* 配置外设允许DMA触发或者配置软件触发

以下是官方解释(([摘自**KV5x Sub-Family Reference Manual** Page 575
](https://www.nxp.com/docs/en/reference-manual/KV5XP144M240RM.pdf))):

>### To initialize the eDMA: 
>*  Write to the CR if a configuration other than the default is desired. 
>* Write the channel priority levels to the DCHPRIn registers if a configuration other than the default is desired. 
>* Enable error interrupts in the EEI register if so desired.
>* Write the 32-byte TCD for each channel that may request service.
>* Enable any hardware service requests via the ERQ register.
>* Request channel service via.


# DMA从内存到内存传输实例

```c
int main(void) {
  /* Init board hardware. */
  BOARD_InitBootPins();
  BOARD_InitBootClocks();
  BOARD_InitDebugConsole();

  SIM->SCGC7 |= SIM_SCGC7_DMA_MASK;   //打开DMA时钟
  SIM->SCGC6 |= SIM_SCGC6_DMAMUX_MASK;//打开DMAMUX时钟

  DMAMUX->CHCFG[0] = 0;//清寄存器
  DMAMUX->CHCFG[0] |= DMAMUX_CHCFG_SOURCE(kDmaRequestMux0AlwaysOn63);//配置通道0的源为63号源
  DMAMUX->CHCFG[0] |= DMAMUX_CHCFG_ENBL_MASK;/使能通道
  
  DMA0->CR=0;//清寄存器
  DMA0->CR |= DMA_CR_GRP0PRI_MASK;//设置group0的优先级为1
  DMA0->EEI |= DMA_EEI_EEI0_MASK;//允许错误中断
  DMA0->INT |= DMA_INT_INT0_MASK;//清中断标志位
  
  DMA0->TCD[0].SADDR=(uint32_t)sendtext; //设置源地址
  DMA0->TCD[0].SOFF=1; //偏移量设置成1,每传输一个字节偏移一个字节
  DMA0->TCD[0].ATTR =0; //每次传输8bit
  DMA0->TCD[0].NBYTES_MLNO=1; //附循环一次
  DMA0->TCD[0].SLAST=0; //传输结束后地址不偏移
  DMA0->TCD[0].DADDR=(uint32_t)receivetext;//设置目标地址
  DMA0->TCD[0].DOFF=1; /偏移量设置成1,每传输一个字节偏移一个字节
  DMA0->TCD[0].CITER_ELINKNO = (unsigned int)(sizeof(sendtext)-1); //主循环次数
  DMA0->TCD[0].DLAST_SGA=0; //传输结束后不处理
  DMA0->TCD[0].CSR |= (DMA_CSR_INTMAJOR_MASK); //主循环后触发中断
  DMA0->TCD[0].BITER_ELINKNO = (unsigned int)(sizeof(sendtext)-1); //与CITER值相同
  
  
  NVIC_EnableIRQ(DMA0_DMA16_IRQn); //允许中断
  DMA0->ERQ |= DMA_EARS_EDREQ_0_MASK; //允许DMA传输
  
  
  while(1);
}
```
实际效果:

![](http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%89456%E5%9B%BE.png)

传输前receivetext为空

![](http://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%8912344%E5%9B%BE.png)

传输后receivetext值和sendtext相同
