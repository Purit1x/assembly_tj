# hw2 & hw3 报告

## hw2

### loop

​	拿一个变量count计算当前行还要输出字符的个数，没到0前直接递增要打印的字符并进行打印。到0后输出换行符，并将count重置为13. 

​	核心代码：

```assembly
output_loop:
    mov ah, 02h  ; 输出当前字符
    mov dl, bl
    int 21h

    dec count  ; 输出一个字符，count--
    jnz no_newline
    ; 要换行则会进入该行
    mov ah, 09h
    lea dx, newline
    int 21h
    mov count, 13  ; 重置计数

no_newline:
    inc bl  ; 准备打印下一个字符
    loop output_loop
```

### jnz

​	由于loop是靠判断cx是否为0来决定是否继续进行循环的，所以只要使用jcxz来显式实现loop就好了，即当cx为0时跳转到结束程序的部分。核心代码如下：

```assembly
output_part:
    mov ah, 02h 
    mov dl, bl
    int 21h

    dec cx
    dec count  ; 输出一个字符cx--,count--
    jnz no_newline
    mov ah, 09h
    lea dx, newline
    int 21h
    mov count, 13

no_newline:
    inc bl
    jcxz end_part
    jmp output_part  ; 还有要输出的部分

end_part:
    mov ah, 4ch
    int 21h
```

### c反汇编

​	使用以下命令：

```bash
gcc -S -masm=intel alphabet_c.c -o alphabet_c.asm
```

​	其中masm选项指定汇编语言风格为intel，gcc反汇编默认的汇编语言风格为AT&T。

## hw3

### 寄存器

​	最终结果存放在ax寄存器中。不断对ax使用div除以10直到商为0。由于div指令将商存储在ax中、余数在dx中，所以可以逐个获取结果从个位到最高位的数字，然后存储在一个buffer中，最后调用21h中断的9号功能进行字符串打印。

​	核心代码：

```assembly
sum_loop:
    add ax, cx
    inc cx
    cmp cx, 101
    jne sum_loop

    lea bx, [buffer]  ; bx指向缓冲区
    add bx, 5  ; 从缓冲区末尾开始填充
    mov BYTE PTR [bx], '$'
    dec bx

    mov cx, 10  ; 除数
convert_loop:
    xor dx, dx
    div cx
    add dl, '0'  ; 将余数转换为ASCII字符
    mov [bx], dl
    dec bx
    test ax, ax  ; 测试商是否为0
    jnz convert_loop
```

### 数据段

​	在数据段中定义一个变量result，大小为一个字，初始化为0. 累加时不累加至ax而是result中。核心代码如下：

```assembly
sum_loop:
    add [result], cx
    inc cx

    cmp cx, 101
    jne sum_loop

    lea bx, [buffer]
    add bx, 5
    mov BYTE PTR [bx], '$'
    dec bx

    mov ax, [result]
    mov cx, 10
convert_loop:
    xor dx, dx
    div cx
    add dl, '0'
    mov [bx], dl
    dec bx
    test ax, ax
    jnz convert_loop
```

### 栈

​	累加时加到ax中，并在累加完成后将ax压入栈。核心代码：

```assembly
sum_loop:
    add ax, cx
    loop sum_loop

    push ax  ; 将ax中结果压入栈
    pop ax

    lea bx, [buffer]
    add bx, 5
    dec bx
    mov cx, 10

convert_loop:
    xor dx, dx
    div cx
    add dl, '0'
    mov [bx], dl
    dec bx
    test ax, ax
    jnz convert_loop
```

### 用户输入

​	处理用户输入较麻烦，需要在数据段中添加一个缓冲区存储用户输入，并将用户输入的字符串转换为一个整数，将这个整数存储到cx寄存器中用于循环。后续打印到屏幕的过程同其它几个文件。代码：

```assembly
.model small
.data
    buffer db 5 dup(0)  ; 存储用户输入
    result db '     $'
    num db 0
    sum dw 0
    newline db 13, 10, '$'
    prompt db 'Enter a number between 1 and 100: $'

.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, prompt
    mov ah, 09h
    int 21h

    ; 读取用户输入
    lea si, buffer + 1
    mov BYTE PTR [buffer], 0  ; 首位存储长度

read_loop:
    mov ah, 1
    int 21h
    cmp al, 13  ; 检查回车
    je input_done
    sub al, '0'

    cmp al, 0
    jl read_loop  ; 检查输入是否合法
    cmp al, 9
    jg read_loop

    mov [si], al  ; 存储当前字符
    inc si  ; 移动到下一个位置
    inc BYTE PTR [buffer]
    cmp BYTE PTR [buffer], 3  ; 最多3位数
    jle read_loop
    jmp input_done

input_done:
    ; 转换输入的数字
    lea si, buffer
    mov cl, [buffer]
    mov bx, 0  ; 存储累加结果
    mov di, 1  ; 乘数
    add si, cx  ; 移动到缓冲区末尾

convert_loop:
    mov al, [si]
    cbw  ; al符号位扩展到ax
    mul di  ; ax = al * di
    add bx, ax
    mov ax, di
    mov dx, 10
    mul dx  ; 更新乘数
    mov di, ax
    dec si
    loop convert_loop
    mov num, bl

    mov cl, num
    mov bx, 0
    mov ax, 1

sum_loop:
    add bx, ax
    inc ax
    loop sum_loop

    lea dx, newline
    mov ah, 09h
    int 21H

    mov ax, bx
    mov cx, 10

    lea bx, [result]
    add bx, 4
cts_loop:
    ; 将结果转换为字符串存储在result中
    xor dx, dx
    div cx
    add dl, '0'
    mov [bx], dl
    dec bx
    test ax, ax
    jnz cts_loop

    lea dx, [result]
    mov ah, 09h
    int 21h

    mov ah, 4ch
    int 21H
main endp
end main
```

### c反汇编

​	同hw2，不再赘述。