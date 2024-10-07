.file "alphabet_c.c"  ; 指定源文件名
.intel_syntax noprefix ; 使用Intel语法，而非AT&T语法
.text                 ; 开始代码段

; 定义printf函数的相关信息
.def printf; .scl 3; .type 32; .endef
.seh_proc printf      ; 标记printf过程开始
printf:
    push rbp          ; 保存基址指针
    .seh_pushreg rbp  ; 记录基址指针到异常处理表
    push rbx          ; 保存rbx寄存器
    .seh_pushreg rbx  ; 记录rbx寄存器到异常处理表
    sub rsp, 56       ; 为局部变量分配栈空间
    .seh_stackalloc 56; 记录栈空间分配到异常处理表
    lea rbp, 48[rsp]  ; 设置rbp指向新的栈帧底部
    .seh_setframe rbp, 48 ; 更新异常处理表中的帧信息
    .seh_endprologue  ; 结束序言部分（初始化工作）

    ; 保存参数到栈中
    mov QWORD PTR 32[rbp], rcx
    mov QWORD PTR 40[rbp], rdx
    mov QWORD PTR 48[rbp], r8
    mov QWORD PTR 56[rbp], r9

    ; 准备调用vfprintf
    lea rax, 40[rbp]
    mov QWORD PTR -16[rbp], rax
    mov rbx, QWORD PTR -16[rbp]
    mov ecx, 1
    mov rax, QWORD PTR __imp___acrt_iob_func[rip]
    call rax
    mov rcx, rax
    mov rax, QWORD PTR 32[rbp]
    mov r8, rbx
    mov rdx, rax
    call __mingw_vfprintf

    ; 处理返回值
    mov DWORD PTR -4[rbp], eax
    mov eax, DWORD PTR -4[rbp]

    ; 恢复栈和寄存器状态，返回
    add rsp, 56
    pop rbx
    pop rbp
    ret
.seh_endproc          ; 标记printf过程结束

; 定义__main函数的相关信息
.def __main; .scl 2; .type 32; .endef

; 定义只读数据段
.section .rdata,"dr"
.LC0:
    .ascii "%c\0"     ; 格式字符串，用于单个字符的输出
.LC1:
    .ascii "\12\0"    ; 字符串，表示换行

; 定义main函数的相关信息
.text
.globl main
.def main; .scl 2; .type 32; .endef
.seh_proc main        ; 标记main过程开始
main:
    push rbp          ; 保存基址指针
    .seh_pushreg rbp  ; 记录基址指针到异常处理表
    mov rbp, rsp      ; 设置新的基址指针
    .seh_setframe rbp, 0 ; 更新异常处理表中的帧信息
    sub rsp, 48       ; 为局部变量分配栈空间
    .seh_stackalloc 48; 记录栈空间分配到异常处理表
    .seh_endprologue  ; 结束序言部分

    call __main       ; 调用C运行时初始化

    ; 初始化变量
    mov BYTE PTR -1[rbp], 97 ; char ch = 'a'
    mov DWORD PTR -8[rbp], 0 ; int i = 0
    mov DWORD PTR -12[rbp], 0; int j = 0

    jmp .L4           ; 跳转到循环条件检查

.L6:                  ; 循环体开始
    ; 打印当前字符
    movsx eax, BYTE PTR -1[rbp]
    mov edx, eax
    lea rax, .LC0[rip]
    mov rcx, rax
    call printf

    ; 增加字符
    movzx eax, BYTE PTR -1[rbp]
    add eax, 1
    mov BYTE PTR -1[rbp], al

    ; 增加计数器i
    add DWORD PTR -8[rbp], 1

    ; 检查是否需要换行
    cmp DWORD PTR -8[rbp], 13
    jne .L5
    lea rax, .LC1[rip]
    mov rcx, rax
    call printf

.L5:                  ; 继续循环
    add DWORD PTR -12[rbp], 1

.L4:                  ; 循环条件检查
    cmp DWORD PTR -12[rbp], 25
    jle .L6           ; 如果j <= 25，则继续循环

    mov eax, 0        ; 设置返回值为0
    add rsp, 48       ; 恢复栈指针
    pop rbp           ; 恢复基址指针
    ret               ; 返回
.seh_endproc          ; 标记main过程结束

.ident "GCC: (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 13.2.0"
.def __mingw_vfprintf; .scl 2; .type 32; .endef