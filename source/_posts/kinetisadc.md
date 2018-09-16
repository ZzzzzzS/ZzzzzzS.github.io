---
title: kinetis KV58 ADC模块食用指南
date: 2018-02-05 14:12:32
tags: [ARM,kinetis,register]
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
cover: https://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/DMA/%E8%8D%89999%E5%9B%BE.png
---

>目前暂时未实现硬件dma触发,目前使用中断软件触发dma搬运,有待进一步改进.

# 程序代码

```c
int main(void) {
  /* Init board hardware. */
  BOARD_InitBootPins();
  BOARD_InitBootClocks();
  BOARD_InitDebugConsole();
  
  
  
  SIM->SCGC6 |= SIM_SCGC6_ADC0_MASK;
  SIM->SCGC6 |= SIM_SCGC6_DMAMUX_MASK;
  SIM->SCGC7 |= SIM_SCGC7_DMA_MASK; 
  
  DMAMUX->CHCFG[0] = 0;
  DMAMUX->CHCFG[0] |= DMAMUX_CHCFG_SOURCE(kDmaRequestMux0Group1ADC0);
  DMAMUX->CHCFG[0] |= DMAMUX_CHCFG_ENBL_MASK;
  
  DMA0->EEI |= DMA_EEI_EEI0_MASK;//允许错误中断
  
  DMA0->TCD[0].SADDR=(uint32_t)&ADC0->R[0]; //设置源地址
  DMA0->TCD[0].SOFF =0; //偏移量设置成1,每传输一个字节偏移一个字节
  DMA0->TCD[0].ATTR =0; //每次传输8bit
  DMA0->TCD[0].NBYTES_MLNO=1; //附循环一次
  DMA0->TCD[0].SLAST=0; //传输结束后地址不偏移
  DMA0->TCD[0].DADDR=(uint32_t)&result;//设置目标地址
  DMA0->TCD[0].DOFF=0; //偏移量设置成1,每传输一个字节偏移一个字节
  DMA0->TCD[0].CITER_ELINKNO = (unsigned int)(1); //主循环次数
  DMA0->TCD[0].DLAST_SGA=0; //传输结束后不处理
  DMA0->TCD[0].CSR |= (DMA_CSR_INTMAJOR_MASK); //主循环后触发中断
  DMA0->TCD[0].BITER_ELINKNO = (unsigned int)(1); //与CITER值相同
  DMA0->TCD[0].CSR &= ~DMA_CSR_DREQ_MASK;
  
  NVIC_EnableIRQ(DMA0_DMA16_IRQn); //允许中断
  //NVIC_EnableIRQ(ADC0_IRQn);
  DMA0->ERQ |= DMA_EARS_EDREQ_0_MASK; //允许DMA传输
  
  
  
  ADC0->CFG1 &=~ADC_CFG1_ADLPC_MASK;
  ADC0->CFG1 |= ADC_CFG1_ADIV(0);
  ADC0->CFG1 |= ADC_CFG1_ADLSMP_MASK;
  ADC0->CFG1 |= ADC_CFG1_MODE(0);
  ADC0->CFG1 |= ADC_CFG1_ADICLK(0);
  
  ADC0->CFG2 |= ADC_CFG2_ADLSTS(0);
  ADC0->CFG2 |= ADC_CFG2_ADHSC_MASK;
  ADC0->CFG2 &=~ADC_CFG2_ADACKEN_MASK;
  ADC0->CFG2 |= ADC_CFG2_MUXSEL(0);
  ADC0->SC2 |= ADC_SC2_DMAEN_MASK;
  
  ADC0->SC1[0]  = ADC_SC1_ADCH(0x0);
  //ADC0->SC1[0] |= ADC_SC1_AIEN_MASK;
  ADC0->SC1[0] &= ~ADC_SC1_DIFF_MASK;
  
  
  //while((ADC0->SC1[0] & ADC_SC1_COCO_MASK) != ADC_SC1_COCO_MASK);
  
  
  //result= (uint16_t)ADC0->R[0];
  
  for(;;) { /* Infinite loop to avoid leaving the main function */
    __asm("NOP"); /* something to use as a breakpoint stop while looping */
  }
}

void DMA0_DMA16_IRQHandler()
{
  gpio_pin_config_t test;
  test.outputLogic=0;
  test.pinDirection=kGPIO_DigitalOutput;
  GPIO_PinInit(GPIOB,17,&test);
  
  DMA0->INT |= DMA_INT_INT0_MASK;//清中断标志位
}

void ADC0_IRQHandler()
{
  DMA0->TCD[0].CSR |=DMA_CSR_START_MASK;
}
```