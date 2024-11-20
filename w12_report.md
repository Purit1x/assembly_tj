# 第12周 课堂练习

## 一、Windows系统程序内存空间分布

| 内存空间 | 描述                                                         |
| -------- | ------------------------------------------------------------ |
| 栈区     | 存放函数的局部变量和函数调用时的参数。 从高地址向低地址扩展。 内存分配和释放是自动的，遵循 LIFO 原则。 |
| 堆区     | 存放动态分配的内存； 从低地址向高地址扩展； 大小动态增长，由程序员控制分配和释放。 |
| 数据段   | 存放全局变量和静态变量；通常紧接在代码段之后；可以被修改，但大小在程序启动时确定。 |
| 代码段   | 存放程序的机器指令；通常位于内存的最低地址处；只读，防止程序修改自身代码。 |

​	从上至下为高地址到低地址。

## 二、系统栈空间

**默认栈空间大小**

1. **32位应用程序**：
    - **默认栈大小**：1 MB
    - **最大栈大小**：通常限制在 2 GB 以内，但这取决于可用的虚拟地址空间。
2. **64位应用程序**：
    - **默认栈大小**：1 MB
    - **最大栈大小**：理论上可以达到 8 TB，但实际上受限于系统的虚拟地址空间和物理内存。

**修改**

​	在Visual Studio中，可以通过链接器选项来查看或调整栈大小，例如：

​	项目->属性->Linker->System: 查看并修改Stack Reserve Size和Stack Commit Size。

## 三、课堂作业

​	c代码：

```c
void func2(int ipt){
    int x2 = ipt+1;
}
void func1(){
    int x1 = 0;
    func2(x1);
}

int main(){
    func1();
    return 0;
}
```

​	反汇编代码：

```assembly
.file	"w12e1.c"            ; 指定源文件名
.intel_syntax noprefix     ; 使用Intel语法，noprefix表示不需要在寄存器前加%

.text                      ; 开始代码段

; func2 函数定义
.globl	func2               ; 声明func2为全局函数
.def	func2; .scl	2; .type	32; .endef ; 定义func2的属性
.seh_proc	func2             ; 标记func2的开始，用于异常处理
func2:
	push	rbp                 ; 保存基址指针（Base Pointer）
	.seh_pushreg	rbp              ; 记录已推入堆栈的基址指针
	mov	rbp, rsp            ; 将栈顶指针（Stack Pointer）赋值给基址指针
	.seh_setframe	rbp, 0           ; 设置帧指针，0表示没有偏移
	sub	rsp, 16             ; 为局部变量分配16字节的空间
	.seh_stackalloc	16              ; 记录分配的栈空间大小
	.seh_endprologue        ; 结束函数序言部分

	mov	DWORD PTR 16[rbp], ecx ; 将传入的参数ecx（通常是函数的第一个参数）保存到栈上的位置16[rbp]
	mov	eax, DWORD PTR 16[rbp] ; 将栈上的值加载到eax寄存器
	add	eax, 1               ; 将eax中的值加1
	mov	DWORD PTR -4[rbp], eax ; 将结果保存到栈上的位置-4[rbp]

	nop                     ; 无操作指令，通常用于占位
	add	rsp, 16             ; 恢复栈指针  
	pop	rbp                 ; 恢复基址指针
	ret                     ; 返回调用者
	.seh_endproc            ; 标记func2结束

; func1 函数定义
.globl	func1               ; 声明func1为全局函数
.def	func1; .scl	2; .type	32; .endef ; 定义func1的属性
.seh_proc	func1             ; 标记func1的开始
func1:
	push	rbp                 ; 保存基址指针
	.seh_pushreg	rbp              ; 记录已推入堆栈的基址指针
	mov	rbp, rsp            ; 将栈顶指针赋值给基址指针
	.seh_setframe	rbp, 0           ; 设置帧指针
	sub	rsp, 48             ; 为局部变量分配48字节的空间
	.seh_stackalloc	48              ; 记录分配的栈空间大小
	.seh_endprologue        ; 结束函数序言部分

	mov	DWORD PTR -4[rbp], 0 ; 在栈上存储一个DWORD，值为0
	mov	eax, DWORD PTR -4[rbp] ; 将栈上的值加载到eax寄存器
	mov	ecx, eax            ; 将eax中的值复制到ecx寄存器
	call	func2              ; 调用func2函数，传入ecx作为参数
	nop                     ; 无操作指令
	add	rsp, 48             ; 恢复栈指针
	pop	rbp                 ; 恢复基址指针
	ret                     ; 返回调用者
	.seh_endproc            ; 标记func1结束

; main 函数定义
.def	__main; .scl	2; .type	32; .endef ; 定义__main的属性
.globl	main                ; 声明main为全局函数
.def	main; .scl	2; .type	32; .endef ; 定义main的属性
.seh_proc	main              ; 标记main的开始
main:
	push	rbp                 ; 保存基址指针
	.seh_pushreg	rbp              ; 记录已推入堆栈的基址指针
	mov	rbp, rsp            ; 将栈顶指针赋值给基址指针
	.seh_setframe	rbp, 0           ; 设置帧指针
	sub	rsp, 32             ; 为局部变量分配32字节的空间
	.seh_stackalloc	32              ; 记录分配的栈空间大小
	.seh_endprologue        ; 结束函数序言部分

	call	__main             ; 调用C运行时初始化函数
	call	func1              ; 调用func1函数
	mov	eax, 0              ; 将返回值0放入eax寄存器
	add	rsp, 32             ; 恢复栈指针
	pop	rbp                 ; 恢复基址指针
	ret                     ; 返回调用者
	.seh_endproc            ; 标记main结束

.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 13.2.0" ; 编译器标识
```

​	反汇编命令：gcc -S -masm=intel w12e1.c -o w12e1.asm

​	从汇编代码中可以看到，在嵌套进行函数调用时，被调用函数的栈空间的开辟是在调用者的栈顶部的基础上继续向下开辟的。传入参数时，依据调用约定将参数存储在栈空间的指定位置。