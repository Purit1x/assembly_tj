assume cs:code,ds:data,es:table
include MACROS.MAC
include DATA.INC
include FUNCS.ASM
code segment
start:
    mov ax, data
    mov ds, ax    ; 设置段寄存器
    mov ax, table
	mov es, ax    ; 设置附加段寄存器

    call clear_screen
    call copy_data ; 拷贝数据段数据到table
    next_line
    mov si, 0
    mov cx, CNT  ; 12次循环
main:
    ; 显示3个空格
    put_spaces 3
    ; 显示年份， 4个字节
    mov al, es:[si]
    put_char al
    mov al, es:[si+1]
    put_char al
    mov al, es:[si+2]
    put_char al
    mov al, es:[si+3]
    put_char al
    add si, 5    ; 跳过5个字节
    ; 显示5个空格
    put_spaces 8
    ;显示 收入
    call print_long
    ; 计算显示的空格
    mov ax, 15
    sub ax, count
    put_spaces ax
    add si, 5    ; 跳过5个字节

    ; 显示雇员数
    mov ax, es:[si]
    call print_int
    mov ax, 15
    sub ax, count
    put_spaces ax
    add si, 3    ; 跳过3个字节

    ; 显示人均收入
    mov ax, es:[si]
    call print_int
    add si, 3    ; 跳过3个字节
    ; 换下一行显示
    next_line
    dec cx
	cmp cx, 0
	je end_main
    jmp main
end_main:

    mov ax, 4c00h ; 返回dos
    int 21h

code ends  
end start 
