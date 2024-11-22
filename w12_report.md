# 第12周 课堂练习

## 一、Windows系统程序内存空间分布

​	编写如下程序：

```c
#include <windows.h>
#include <stdio.h>

int global_var = 42; // 全局变量

void print_memory_layout() {
    // 获取模块基地址（代码部分的起始地址）
    HMODULE hModule = GetModuleHandle(NULL);
    if (hModule == NULL) {
        printf("Failed to get module handle.\n");
        return;
    }
    printf("Code section start address: %p\n", hModule);

    // 获取全局变量的地址
    printf("Global variable address: %p\n", &global_var);

    // 获取堆区的起始地址
    void* heap_start = HeapAlloc(GetProcessHeap(), 0, 1);
    if (heap_start == NULL) {
        printf("Failed to allocate memory on heap.\n");
        return;
    }
    printf("Heap start address: %p\n", heap_start);
    HeapFree(GetProcessHeap(), 0, heap_start);

    // 获取栈区的起始地址
    int stack_var;
    printf("Stack start address (stack bottom): %p\n", (void*)&stack_var);
}

int main() {
    print_memory_layout();
    return 0;
}
```

​	运行得到以下输出结果：

```
Code section start address: 00007ff78caf0000
Global variable address: 00007ff78caf8000
Heap start address: 000001c3193b6a70
Stack start address (stack bottom): 00000008adfffe1c
```

​	可以看到全局变量部分，即数据段与代码段是紧邻的，而堆区和栈区是分开存储的。

​	而如果使用针对x86平台的编译器，得到以下输出结果：

```
Code section start address: 00750000
Global variable address: 0076A000
Heap start address: 0137ACE0
Stack start address (stack bottom): 010FF9F4
```

​	可以看到，数据段与代码段仍是紧邻的，位于低地址区域，而堆区和栈区位于高地址区域。

## 二、系统栈空间

**默认栈空间大小**

​	使用如下程序：

```c++
#include <windows.h>
#include <cstdio>

int main(int argc, char* argv[])
{
	ULONG_PTR lowAddr, highAddr;
	GetCurrentThreadStackLimits(&lowAddr, &highAddr);
	size_t stackSizeByte = highAddr - lowAddr;
	float stackSizeMB = static_cast<float>(stackSizeByte) / 1024 / 1024;
	printf("Stack size: %.02f MB Stack bottom: %p, Stack top %p", stackSizeMB, reinterpret_cast<void*>(lowAddr), reinterpret_cast<void*>(highAddr));
	return 0;
}
```

​	得到输出结果为：

​	`Stack size: 1.00 MB Stack bottom: 0000007FED400000, Stack top 0000007FED500000`

​	以x86为解决方案平台得到的栈空间大小相同。

**修改**

​	在Visual Studio中，可以通过链接器选项来查看或调整栈大小，例如：

​	项目->属性->Linker->System: 查看并修改Stack Reserve Size和Stack Commit Size。

​	将“堆栈保留大小”修改为2097152（bytes）后，得到输出结果如下：
​	`Stack size: 2.00 MB Stack bottom: 000000D709E00000, Stack top 000000D70A000000`

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