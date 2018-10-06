---
title: kinetis KV58 HSADC模块食用指南
date: 2018-02-04 14:12:32
tags: [ARM,kinetis,register]
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
cover: https://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%89999%E5%9B%BE.png
---

>时间不多,今天这个模块就简单说以下吧.

# HSADC模块简单介绍

kv58有adc模块,也有个人感觉功能更强大的HSADC模块.kv58拥有两个12bit的hsadc模块,最高采集速度可以到5mhz,可以采集140khz~80mhz的信号.有AB通道可以同时采集,也就是说kv58可以做到4通道同时采集.另外还有支持通道乱序扫描可以做到一次触发扫描全部16个通道,相比于adc模块需要不断触发和ping-pong采集来说,hsadc的确做得更加出色.另外,hsadc模块所有通道都支持差分输入,相比于adc只有4个通道(kv58只有两个通道)支持差分输入,配置更加灵活.此外,还有过零中断,超限中断,各种错误中断等等,也可以实现adc的比较功能.

# HSADC模块结构简图

![](https://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/HSADC/%E8%8D%89%E5%9B%BE.png)


![](https://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/HSADC/%E8%8D%89%E5%9B%BE2.png)

可以看出,整个结构相对于adc来说更加简洁.值得注意的是8~17通道的复用情况,需要配置相关寄存器实现复用.

# HSADC软件触发中断(查询)示例
## 主程序

```c
/**
 * This is template for main module created by MCUXpresso Project Generator. Enjoy!
 **/

#include <string.h>

#include "board.h"
#include "pin_mux.h"
#include "clock_config.h"

uint16_t result;

/*!
 * @brief Application entry point.
 */
int main(void) {
  /* Init board hardware. */
  BOARD_InitBootPins();   //设置管脚复用功能
  BOARD_InitBootClocks(); 
  BOARD_InitDebugConsole();

  /* Add your code here */

  /* Create RTOS task */
  
  
  SIM->SCGC5 |= SIM_SCGC5_HSADC0_MASK;  //打开时钟
  NVIC_EnableIRQ(HSADC0_CCA_IRQn);		//运行中断
  //HSADC0->PWR&=~HSADC_PWR_PDA_MASK;		
  HSADC0->PWR=0;						//PWR寄存器全0,AB通道上电,关闭延迟上电功能
  HSADC0->CTRL1&=~HSADC_CTRL1_SMODE_MASK;	//清寄存器
  HSADC0->CTRL1|= HSADC_CTRL1_SMODE(4);		//设置为默认模式
  HSADC0->CTRL1|= HSADC_CTRL1_DMAENA_MASK;	//允许DMA
  HSADC0->CTRL1|= HSADC_CTRL1_EOSIEA_MASK;  //允许扫描完成中断发生
  HSADC0->CTRL1&=~HSADC_CTRL1_STOPA_MASK;	//关闭停止模式,打开通道
  HSADC0->CTRL2|= HSADC_CTRL2_DIVA(2);		//设置分频,HSRUN模式下频率不能高于80Mhz
  
  HSADC0->SDIS = 0xFFFE;					//设置扫描的组,只扫描一组
  
  HSADC0->CTRL3 |= HSADC_CTRL3_ADCRES(3);	//设置精度为12bit
  HSADC0->CTRL3 |= HSADC_CTRL3_DMASRC_MASK; //DMA触发源
  
  HSADC0->SCINTEN |= 1;						//允许中断发生
  
  HSADC0->CTRL1 |= HSADC_CTRL1_STARTA_MASK; //软件触发扫描
  
  
  //查询方式
  //while((HSADC0->RDY & HSADC_RDY_RDY(0))!= HSADC_RDY_RDY(0));	
  //result=HSADC0->RSLT[0];

  for(;;) { /* Infinite loop to avoid leaving the main function */
    /* something to use as a breakpoint stop while looping */
  }
}

void HSADC0_CCA_IRQHandler()
{
	//中断方式
  gpio_pin_config_t test; //开一个灯证明进入了中断
  test.outputLogic=0;
  test.pinDirection=kGPIO_DigitalOutput;
  GPIO_PinInit(GPIOB,17,&test);
  result=HSADC0->RSLT[0];
  HSADC0->STAT |= HSADC_STAT_EOSIA_MASK ; //清中断标志位
}
```

## 管脚分配

```c

void BOARD_InitPins(void) {
  CLOCK_EnableClock(kCLOCK_PortB);                           /* Port B Clock Gate Control: Clock enabled */
  CLOCK_EnableClock(kCLOCK_PortE);                           /* Port E Clock Gate Control: Clock enabled */

  PORT_SetPinMux(PORTB, PIN17_IDX, kPORT_MuxAsGpio);         /* PORTB17 (pin 63) is configured as PTB17 */
  PORT_SetPinMux(PORTE, PIN16_IDX, kPORT_PinDisabledOrAnalog); /* PORTE16 (pin 10) is configured as HSADC0A_CH0 */
}
```

***
# EOF