---
title: ARM寄存器食用感受
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
date: 2018-1-22 23:41:34
tags: [ARM,kinetis,register]
cover: https://zzshubimage-1253829354.file.myqcloud.com/%E5%AF%84%E5%AD%98%E5%99%A8%E9%A3%9F%E7%94%A8/1F2101110-5%5B1%5D.jpg
---

# ARM寄存器食用感受

> 最近研究NXP新推出的**kinetis KV58**微控制器,用的是NXP官方推出的MCUXpresso的SDK,研究后发现并没有想象的好用,故决定还是手撸寄存器好了.

# MKV58F24.h

首先需要关注这个头文件,该头文件中包含了KV58微控制器所有寄存器地址,是最重要的头文件.下面以**GPIO**为例,介绍一下撸寄存器的方法.操作每个模块主要可以分为3部分.
* 地址定义
* 寄存器结构体定义
* 操作掩码宏定义

此外,手册中还定义了其他内容,如中断向量表,DMA触发源表,编译器设置,版本信息等等.

## 地址定义

```c
/*!
 * @}
 */ /* end of group GPIO_Register_Masks */


/* GPIO - Peripheral instance base addresses */
/** Peripheral GPIOA base address */
#define GPIOA_BASE                               (0x400FF000u)
/** Peripheral GPIOA base pointer */
#define GPIOA                                    ((GPIO_Type *)GPIOA_BASE)
/** Peripheral GPIOB base address */
#define GPIOB_BASE                               (0x400FF040u)
/** Peripheral GPIOB base pointer */
#define GPIOB                                    ((GPIO_Type *)GPIOB_BASE)
/** Peripheral GPIOC base address */
#define GPIOC_BASE                               (0x400FF080u)
/** Peripheral GPIOC base pointer */
#define GPIOC                                    ((GPIO_Type *)GPIOC_BASE)
/** Peripheral GPIOD base address */
#define GPIOD_BASE                               (0x400FF0C0u)
/** Peripheral GPIOD base pointer */
#define GPIOD                                    ((GPIO_Type *)GPIOD_BASE)
/** Peripheral GPIOE base address */
#define GPIOE_BASE                               (0x400FF100u)
/** Peripheral GPIOE base pointer */
#define GPIOE                                    ((GPIO_Type *)GPIOE_BASE)
/** Array initializer of GPIO peripheral base addresses */
#define GPIO_BASE_ADDRS                          { GPIOA_BASE, GPIOB_BASE, GPIOC_BASE, GPIOD_BASE, GPIOE_BASE }
/** Array initializer of GPIO peripheral base pointers */
#define GPIO_BASE_PTRS                           { GPIOA, GPIOB, GPIOC, GPIOD, GPIOE }

/*!
 * @}
 */ /* end of group GPIO_Peripheral_Access_Layer */

 ```

 可以看出,文件中定义了各gpio寄存器的首地址``GPIOx_BASE``,定义了指向首地址的指针``GPIOx``.使用宏定义的方式可以显著减少代码量,采用首地址加偏移量的方式就可以访问各个寄存器了.

 ***

 ## 寄存器结构体

 ```c
 /*!
 * @addtogroup GPIO_Peripheral_Access_Layer GPIO Peripheral Access Layer
 * @{
 */

/** GPIO - Register Layout Typedef */
typedef struct {
  __IO uint32_t PDOR;                              /**< Port Data Output Register, offset: 0x0 */
  __O  uint32_t PSOR;                              /**< Port Set Output Register, offset: 0x4 */
  __O  uint32_t PCOR;                              /**< Port Clear Output Register, offset: 0x8 */
  __O  uint32_t PTOR;                              /**< Port Toggle Output Register, offset: 0xC */
  __I  uint32_t PDIR;                              /**< Port Data Input Register, offset: 0x10 */
  __IO uint32_t PDDR;                              /**< Port Data Direction Register, offset: 0x14 */
} GPIO_Type;

```

这就是gpio类型的结构体,gpio类型的指针可以访问寄存器,以首地址加偏移量的方式就可以访问整个寄存器中任意位置.值得注意的是其中的``__IO``和``__o``,它们意义如下:

```c
/* IO definitions (access restrictions to peripheral registers) */
#ifdef __cplusplus
  #define   __I     volatile             /*!< defines 'read only' permissions                 */
#else
  #define   __I     volatile const       /*!< defines 'read only' permissions                 */
#endif
#define     __O     volatile             /*!< defines 'write only' permissions                */
#define     __IO    volatile             /*!< defines 'read / write' permissions              */ 

```

***


## 操作掩码宏定义

```c
* ----------------------------------------------------------------------------
   -- GPIO Register Masks
   ---------------------------------------------------------------------------- */

/*!
 * @addtogroup GPIO_Register_Masks GPIO Register Masks
 * @{
 */

/*! @name PDOR - Port Data Output Register */
#define GPIO_PDOR_PDO_MASK                       (0xFFFFFFFFU)
#define GPIO_PDOR_PDO_SHIFT                      (0U)
#define GPIO_PDOR_PDO(x)                         (((uint32_t)(((uint32_t)(x)) << GPIO_PDOR_PDO_SHIFT)) & GPIO_PDOR_PDO_MASK)

/*! @name PSOR - Port Set Output Register */
#define GPIO_PSOR_PTSO_MASK                      (0xFFFFFFFFU)
#define GPIO_PSOR_PTSO_SHIFT                     (0U)
#define GPIO_PSOR_PTSO(x)                        (((uint32_t)(((uint32_t)(x)) << GPIO_PSOR_PTSO_SHIFT)) & GPIO_PSOR_PTSO_MASK)

/*! @name PCOR - Port Clear Output Register */
#define GPIO_PCOR_PTCO_MASK                      (0xFFFFFFFFU)
#define GPIO_PCOR_PTCO_SHIFT                     (0U)
#define GPIO_PCOR_PTCO(x)                        (((uint32_t)(((uint32_t)(x)) << GPIO_PCOR_PTCO_SHIFT)) & GPIO_PCOR_PTCO_MASK)

/*! @name PTOR - Port Toggle Output Register */
#define GPIO_PTOR_PTTO_MASK                      (0xFFFFFFFFU)
#define GPIO_PTOR_PTTO_SHIFT                     (0U)
#define GPIO_PTOR_PTTO(x)                        (((uint32_t)(((uint32_t)(x)) << GPIO_PTOR_PTTO_SHIFT)) & GPIO_PTOR_PTTO_MASK)

/*! @name PDIR - Port Data Input Register */
#define GPIO_PDIR_PDI_MASK                       (0xFFFFFFFFU)
#define GPIO_PDIR_PDI_SHIFT                      (0U)
#define GPIO_PDIR_PDI(x)                         (((uint32_t)(((uint32_t)(x)) << GPIO_PDIR_PDI_SHIFT)) & GPIO_PDIR_PDI_MASK)

/*! @name PDDR - Port Data Direction Register */
#define GPIO_PDDR_PDD_MASK                       (0xFFFFFFFFU)
#define GPIO_PDDR_PDD_SHIFT                      (0U)
#define GPIO_PDDR_PDD(x)                         (((uint32_t)(((uint32_t)(x)) << GPIO_PDDR_PDD_SHIFT)) & GPIO_PDDR_PDD_MASK)


/*!
 * @}
 */ /* end of group GPIO_Register_Masks */

 ```
 这部分主要定义了各种掩码和偏移量,方便操作寄存器,减少代码书写量.

 # MASK SHIFT (X)是什么

 开始看寄存器最不理解的就是掩码宏定义这一部分,不过各种掩码操作熟练以后确实能够很高效的操作寄存器.
 ## MASK
 mask本意为遮挡,观察后发现掩码用于给某一寄存器赋1或0.
 比如将SPI当中的MTFE寄存器赋值1,只需要:
 ```c
 SPI_MCR_REG(SPIN[spin]) = ( 0 | SPI_MCR_HALT_MASK);        //停止SPI传输

 ```

如果需要将寄存器赋值0,只需要:

 ```c
 SPI_MCR_REG(SPIN[spin]) = ( 0 & ~SPI_MCR_HALT_MASK);        //开始SPI传输

 ```

 ## shift
 注意shift当中的值都是用十进制表示的,在这里,shift表示偏移量,就是寄存器相对首地址偏移的位置.

 ## (x)
 配合shift和mask,操作寄存器就变得简单了,这里(x)的意思就是将这个位置0或1,写法如下:
```c
//置1
 SPI_MCR_REG(SPIN[spin]) =  (0|  SPI_MCR_PCSIS(pcs));

//置0
 SPI_MCR_REG(SPIN[spin]) =  (0 &  ~SPI_MCR_PCSIS(pcs));


//其中 

typedef enum
{
    SPI_PCS0 = 1 << 0,
    SPI_PCS1 = 1 << 1,
    SPI_PCS2 = 1 << 2,
    SPI_PCS3 = 1 << 3,
    SPI_PCS4 = 1 << 4,
    SPI_PCS5 = 1 << 5,
} SPI_PCSn_e;
```
# KV5x Sub-Family Reference Manual

[https://www.nxp.com/docs/en/reference-manual/KV5XP144M240RM.pdf](https://www.nxp.com/docs/en/reference-manual/KV5XP144M240RM.pdf)

# KV5x Data Sheet

[https://www.nxp.com/docs/en/data-sheet/KV5XP144M240.pdf](https://www.nxp.com/docs/en/data-sheet/KV5XP144M240.pdf)