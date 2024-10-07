.file	"sum.c"  ; 源文件名
.intel_syntax noprefix  ; 使用Intel语法，不使用前缀

.text  ; 代码段开始

; 定义printf函数
.def	printf;	.scl	3;	.type	32;	.endef
.seh_proc	printf  ; 开始定义printf过程
printf:
	push	rbp  ; 保存基址指针
	.seh_pushreg	rbp  ; 告诉SEH框架保存了rbp
	push	rbx  ; 保存rbx寄存器
	.seh_pushreg	rbx  ; 告诉SEH框架保存了rbx
	sub	rsp, 56  ; 为局部变量分配栈空间
	.seh_stackalloc	56  ; 告诉SEH框架分配了56字节的栈空间
	lea	rbp, 48[rsp]  ; 设置rbp为新的栈帧基址
	.seh_setframe	rbp, 48  ; 告诉SEH框架新的栈帧基址
	.seh_endprologue  ; 结束函数序言

	; 保存传入参数
	mov	QWORD PTR 32[rbp], rcx  ; 保存第一个参数
	mov	QWORD PTR 40[rbp], rdx  ; 保存第二个参数
	mov	QWORD PTR 48[rbp], r8  ; 保存第三个参数
	mov	QWORD PTR 56[rbp], r9  ; 保存第四个参数

	; 保存局部变量
	lea	rax, 40[rbp]
	mov	QWORD PTR -16[rbp], rax  ; 保存局部变量地址
	mov	rbx, QWORD PTR -16[rbp]  ; 将局部变量地址加载到rbx

	; 初始化计数器
	mov	ecx, 1  ; 计数器初始值为1

	; 获取标准输出流
	mov	rax, QWORD PTR __imp___acrt_iob_func[rip]
	call	rax  ; 调用__acrt_iob_func函数
	mov	rcx, rax  ; 将标准输出流地址保存到rcx

	; 调用vfprintf函数
	mov	rax, QWORD PTR 32[rbp]  ; 获取格式字符串地址
	mov	r8, rbx  ; 获取可变参数列表地址
	mov	rdx, rax  ; 将格式字符串地址加载到rdx
	call	__mingw_vfprintf  ; 调用vfprintf函数

	; 保存返回值
	mov	DWORD PTR -4[rbp], eax  ; 保存vfprintf的返回值

	; 返回
	mov	eax, DWORD PTR -4[rbp]  ; 将返回值加载到eax
	add	rsp, 56  ; 恢复栈指针
	pop	rbx  ; 恢复rbx寄存器
	pop	rbp  ; 恢复基址指针
	ret  ; 返回调用者
.seh_endproc  ; 结束定义printf过程

; 定义__main函数
.def	__main;	.scl	2;	.type	32;	.endef

; 定义常量字符串
.section .rdata,"dr"
.LC0:
	.ascii "%d\0"  ; 格式字符串"%d"

.text  ; 代码段开始

; 定义main函数
.globl	main
.def	main;	.scl	2;	.type	32;	.endef
.seh_proc	main  ; 开始定义main过程
main:
	push	rbp  ; 保存基址指针
	.seh_pushreg	rbp  ; 告诉SEH框架保存了rbp
	mov	rbp, rsp  ; 设置rbp为新的栈帧基址
	.seh_setframe	rbp, 0  ; 告诉SEH框架新的栈帧基址
	sub	rsp, 48  ; 为局部变量分配栈空间
	.seh_stackalloc	48  ; 告诉SEH框架分配了48字节的栈空间
	.seh_endprologue  ; 结束函数序言

	; 初始化全局环境
	call	__main  ; 调用__main函数

	; 初始化变量
	mov	DWORD PTR -4[rbp], 0  ; 初始化sum为0
	mov	DWORD PTR -8[rbp], 1  ; 初始化i为1

	; 循环计算1到100的和
	jmp	.L4  ; 跳到循环条件检查
.L5:
	mov	eax, DWORD PTR -8[rbp]  ; 将i加载到eax
	add	DWORD PTR -4[rbp], eax  ; 将i加到sum上
	add	DWORD PTR -8[rbp], 1  ; i递增1
.L4:
	cmp	DWORD PTR -8[rbp], 100  ; 检查i是否小于等于100
	jle	.L5  ; 如果i <= 100，继续循环

	; 打印结果
	mov	eax, DWORD PTR -4[rbp]  ; 将sum加载到eax
	mov	edx, eax  ; 将sum加载到edx
	lea	rax, .LC0[rip]  ; 获取格式字符串地址
	mov	rcx, rax  ; 将格式字符串地址加载到rcx
	call	printf  ; 调用printf函数

	; 返回
	mov	eax, 0  ; 设置返回值为0
	add	rsp, 48  ; 恢复栈指针
	pop	rbp  ; 恢复基址指针
	ret  ; 返回调用者
.seh_endproc  ; 结束定义main过程

.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 13.2.0"  ; 编译器版本信息

; 定义__mingw_vfprintf函数
.def	__mingw_vfprintf;	.scl	2;	.type	32;	.endef