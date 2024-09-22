# helloworld

## 一、正常输出

### 1. 源码一

```assembly
.model small
.data
Hello     DB 'Hello world!',0dh,0ah,'$'
.code
START:     MOV AX,@DATA
        MOV DS,AX
        LEA DX,Hello
        MOV AH,9
        INT 21H          
               
        MOV AX,4C00H
    INT 21h
END    START
```

![image-20240922153042809](.\img\image-20240922153042809.png)

​	可以看到，第三条指令，也就是LEA（装载有效地址）向DX中装载的是0002中的内容，也就是hello。

### 2. 源码二

```assembly
.model small
.data
Hello     DB 'Hello world!',0dh,0ah,'$'
.code
START:     MOV AX,@DATA
        MOV DS,AX
        MOV DX,offset Hello
        MOV AH,9
        INT 21H          
               
        MOV AX,4C00H
    INT 21h
END    START 
```

​							![image-20240922153647722](.\img\image-20240922153647722.png)	

​	可以看到，第三条地址MOV是将hello的偏移量0002移动到DX中。

## 二、另类执行

1. 在汇编阶段选择生成列表文件（*.lst）‐‐可直接用写字板打开（显示地址、内容、源码等 对应关系）

![image-20240922155945943](.\img\image-20240922155945943.png)

2. 在汇编阶段选择生成交叉引用文件（*.crf）‐‐不能直接用写字板打开，用 CREF 工具转成 *.ref 文件后可用写字板浏览。（显示符号的定义及引用位置）

![image-20240922160221062](.\img\image-20240922160221062.png)

3. 直接写内存方式执行代码： 
    1. A）写数据”Hello$”对应的 ASCII 码 48 65 6c 6c 6f 24 写入内存 Debug 下用‐e 076a：0 回车 一次写入（用空格自动分开了）‐‐‐‐‐‐相当于 DS：076A 
    2. B） 写代码的机器码 b8 6b 07 be d8 ba 02 00 b4 09 cd 21 b8 00 4c cd 21（17 个字节）写入内存 Debug 下用‐e 076b：0 回车 一次写入（用空格自动分开了）‐‐‐‐‐‐相当于 CS：076B 
    3. C） 修改寄存器及执行

​	![image-20240922173724148](.\img\image-20240922173724148.png)
