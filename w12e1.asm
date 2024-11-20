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