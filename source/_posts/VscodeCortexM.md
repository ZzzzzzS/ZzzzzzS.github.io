---
title: 使用VSCode开发Cortex-M系列芯片
date: 2020-10-04 14:12:32
tags: [kinetis,VSCode,GCC]
mathjax: false
author: 
 nick: ZZS
 link: https://zzzzzzs.github.io/
cover: https://zzshubimage-1253829354.file.myqcloud.com/VSCodeCortexM/cover.png
---

# 使用VSCode开发Cortex-M系列芯片

> 最近实在是受不了那些基于eclipse的IDE来开发arm了，界面太丑，而且自动补全功能不好用，于是准备使用vscode加上一系列的开源工具链来开发。其实也可以使用VisualGDB+Visual Studio来开发，但是我觉得还是太重了。

# 使用的工具

* Visual Studio Code
* Cmake
* GNU Arm Embedded Toolchain
* OpenOCD
* Cmake tool(VSC的插件)
* Cortex-Debug(VSC的插件)

# 硬件介绍

这里我使用的是NXP的[FRDM-KL02Z](https://www.nxp.com/design/development-boards/freedom-development-boards/mcu-boards/freedom-development-platform-for-the-kinetis-kl02-family:FRDM-KL02Z)开发板，这个开发板使用板载的OpenSDA调试器来调试，自带的OpenSDA支持三种调试接口，分别是PEMicro，CMSIS-DAP，JLink。此外，它还支持将bin文件直接拖拽进虚拟出来的储存设备的方式来下载程序。使用不同的调试接口需要给OpenSDA刷入不同的固件，关于固件的详细信息可以参考[NXP的网站](https://www.nxp.com/design/microcontrollers-developer-resources/ides-for-kinetis-mcus/opensda-serial-and-debug-adapter:OPENSDA)。

我在这里使用的是CMSIS-DAP的接口，主要是因为PEMicro和Jlink的GDBServer不好找(不开源，不想用盗版等原因)。

关于SDK，这里我使用的NXP的MCUXpresso。用MCUXpresso Config Tools能够生成适用于各种开发平台的工程，这里使用的是gcc工具链，它自动使用cmake来管理工程。

![](https://zzshubimage-1253829354.file.myqcloud.com/VSCodeCortexM/xpresso.png)


# 开发流程

```flow
Xpresso=>operation: 生成CMake工程
Config=>operation: 在VSC中配置Cmake
Build=>operation: 编译
ConfigDebug=>operation: 配置调试器
Debug=>operation: 调试

Xpresso->Config->Build->ConfigDebug->Debug
```
由此可见过程可以分为编译和下载调试两部分。编译部分使用CMake+GNU toolchain来生成elf文件。下载调试部分使用GNU toolchain中的GDB来调试，使用OpenOCD来做GDBServer。

# 配置CMake

由MCUXpresso生成的工程自带``CMakeLists.txt``和``toolchain file``，我们只需要指定``toolchain file``给vsc的cmake插件就可以自动配置必要的编译环境了，我最开始还走了一些弯路，想着手动配置编译器。根据[CMake的文档](https://vector-of-bool.github.io/docs/vscode-cmake-tools/kits.html?highlight=toolchain)：**在``.vscode``文件夹中创建``cmake-kits.json``文件，并输入以下内容**

```json

//cmake-kits.json
[
    {
    "name": "arm-gcc",
    "toolchainFile": "${workspaceFolder}/armgcc.cmake"
}
]
```
然后还需要指定``generator``的类型，在工程的``.vscode/settings.json``中指定``MinGW Makefiles``。由于这个``toolchain file``中使用了``ARMGCC_DIR``这个变量，所以要么在系统的环境变量中添加，要么在``settings.json``中一并添加。

```json
//settings.json
{
    "cmake.generator": "MinGW Makefiles",
    "cmake.environment": {
        "ARMGCC_DIR": "C:\\Program Files (x86)\\GNU Arm Embedded Toolchain\\9 2020-q2-update\\"
    },
    "C_Cpp.default.configurationProvider": "ms-vscode.cmake-tools"
}
```

之后在选择``cmake configuration``的时候就会出现刚刚添加的选项，选择这个选项就好了，**不要自己在``settings.json``中配置编译器，prefix，args等等！**
![](https://zzshubimage-1253829354.file.myqcloud.com/VSCodeCortexM/cmake.png)

完成上述配置之后，应该直接编译就能生成``.elf``文件了。上述操作等效于以下命令：
```shell
cmake -DCMAKE_TOOLCHAIN_FILE="armgcc.cmake" -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=debug  .
mingw32-make
```

# 配置调试

关于Cortex-M系列的调试，这里也是用的GDB+GDBServer的模式，GDB对应的GNU工具链中的GDB，使用OpenOCD作为GDBServer。其实本可以在``task.json``中手动配置并启动OpenOCD，然后在``launch.json``中配置并启动GDB来下载调试，但是这样过程有些繁琐。好在我发现了``Cortex-Debug``这个插件，可以帮助我们完成上诉操作。由上述所述，调试配置包含启动OpenOCD和启动GDB两个部分，首先需要在全局``settings.json``中指定``Cortex-Debug``需要的GDB和openOCD的位置。之后创建``launch.json``输入以下内容：

```json
//launch.jsom
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Cortex Debug",
            "cwd": "${workspaceRoot}",
            "executable": "./build/Debug/hello_world.elf",
            "request": "launch",
            "type": "cortex-debug",
            "servertype": "openocd",
            "configFiles": ["interface/cmsis-dap.cfg","target/klx.cfg"],
            "searchDir": ["C:\\ProgramFiles\\OpenOCD\\share\\openocd\\scripts"],
            "runToMain": true
        }
    ]
}
```
可能不好理解的是``servertype``,``configFiles``和``searchDir``三个字段。这都是启动openOCD相关的指令，等效命令行为：
```shell
openocd.exe -s "C:\ProgramFiles\OpenOCD\share\openocd\scripts" -f interface/cmsis-dap.cfg -f target/klx.cfg
```
openocd是使用tcl脚本语言来工作的。``-f``后面的两个参数分别指定了使用的调试接口和芯片类型，由于没有对应的文件这里kl02z使用klx.cfg;``-s``参数指定了搜索这些tcl脚本的位置，其实就是openocd的安装目录。

之后直接启动调试，就能自动下载并开始调试了。

![](https://zzshubimage-1253829354.file.myqcloud.com/VSCodeCortexM/debug.png)

***
EOF