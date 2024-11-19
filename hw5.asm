assume cs:code,ds:data,es:table
data segment
CNT equ 21 ;一共21年
year label word
        db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
        db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
        db '1993','1994','1995' ;以上是表示21年的21个字符串 
income label word    
        dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
        dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
        ;以上是表示21年公司总收入的21个dword型数据  
amount label word        
        dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
        dw 11542,14430,45257,17800
        ;以上是表示21年公司雇员人数的21个word型数据
screen_pos 	dw 0 ; 屏幕位置， 起始是0
count dw 0   ; 4字节整数的位数
data ends   
table segment
db 21 dup('year summ ne ?? ') ;年份--year，收入--summ, 雇员数--ne
table ends
; 屏幕输出一个字符
put_char macro char
	push cx
	mov cl, char
    mov ch, 04h  ; 前景色红色
    call show_char
    pop cx
endm
;屏幕换行
next_line macro 
    push ax
    push bx

    mov ax, screen_pos
    mov bl, 80
    div bl
    inc al
    mul bl
    mov screen_pos, ax

    pop bx
    pop ax
endm
;输出num个空格字符
put_spaces macro num
	local ls
	push cx
	mov cx,num
ls:
	put_char ' '
	loop ls
	pop cx
endm
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
clear_screen proc
	push es
	mov ax, 0B800h;
	mov es, ax;
	mov di, 0
	mov ah, 07h
	mov al, 20h;空格
	mov cx, 2000;80*25
	rep stosw
	mov screen_pos,0 ;屏幕位置清0
	pop es
	ret
clear_screen endp
; 拷贝数据到他table段
copy_data proc
    mov di, 0 ;table地址

    mov si, 0 ; 每次索引+4
    mov bx, 0 ; 每次索引+2
    mov cx, CNT ; 循环12次 
copy_loop: 
    ;复制年份，4个字节一组
    mov ax, year[si]
    mov es:[di], ax
    mov dx, year[si+2]
    mov es:[di+2], dx
    add di, 5 ;  增加5个字节的位置

    ; 复制收入， 4个字节一组
    ; dx: ax
    mov ax, income[si]
    mov es:[di], ax
    mov dx, income[si+2]
    mov es:[di+2], dx 
    add di, 5 ;  增加5个字节的位置

    push cx  ; 保存cx 寄存器
    ; 复制人员， 2个字节一组
    mov cx, amount[bx]
    mov es:[di], cx
    add di, 3 ;  增加3个字节的位置
    
    ; 计算人均收入= income/amount
    ; 总收入 dx:ax
    div cx
    mov es:[di], ax  ; 结果保存在ax
    add di, 3 ;  增加3个字节的位置

    add si, 4 ; 每次增加4个字节
    add bx, 2 ; 每次增加2个字节
    pop cx    ; 恢复cx寄存器
    dec cx
    jnz copy_loop

    ret
copy_data endp
;屏幕显示彩色的字符
;cl 是字符
;ch 是颜色
show_char proc
	push ax ; 保存使用的寄存器
	push bx
	push bp
	push es
	
	mov ax, screen_pos
	shl ax, 1
	mov bp, ax
	mov ax, 0B800h;
	mov es, ax;
	mov es:[bp], cx;
	inc screen_pos ;位置加1
	
	pop es ; 恢复使用的寄存器
	pop bp
	pop bx
	pop ax
	ret
show_char endp
; 显示4字节的长整数
print_long proc  
	push ax ;保存寄存器环境
	push bx
	push cx
	push dx
    push si

    mov cx, 0 ; 计数=0
Long:
    inc cx   ; 循环计数
    ;si开始的4个字节	
    ;4字节除法, 除以10然后返回余数
    mov dx, 0
    mov ax, es:[si+2] ; 高16位先除以10
    mov bx, 10
    div bx
    ;计算结果保存到dx
    mov es:[si+2], ax ; 保存高位计算结果

    mov ax, es:[si]   ; 低16位接着除以10
    div bx
    push dx           ; 保存余数， 入栈

    mov es:[si], ax   ; 保存低位计算结果
    cmp ax, 0         ; 检查低位是否为0
    jne Long 
	mov ax, es:[si+2] ; 检查高位是否为0
    cmp ax, 0
    jne Long 

	mov count, cx  ; 保存整数位数
print:
    pop ax
    add al, 30h     ; 转asc码 
    put_char al
    loop  print

    pop si
	pop dx ;恢复寄存器环境
	pop cx
	pop bx
	pop ax
    ret
print_long endp	
;显示一个二进制的十进制  show_int
;调用之前 整数存到ax里
;整数值转asc码字符串输出
;寄存器传值,整数值在AX里面
print_int proc
	push ax ;保存寄存器环境
	push bx
	push cx
	push dx

;ax = 123
; 123/10 = 12....3
; 12/10 = 1......2
; 1/10 = 0....  .1
;push 1 .... pop 1
;push 2          2 
;push 3          3

; '1' = '0'+1 = 30h+ 1h = 31h
; '2' = 32h
; '3' = 33h
	mov cx, 0  ;统计位数count
	mov bx, 10 ; 除数
Ldiv:
    mov dx, 0  ;dx清0，准备除法
    div bx     ;整数AX除以10
    push dx    ;余数dx入栈
    inc cx     ;count+1  
    cmp ax, 0  ;遇到0结束
    jne Ldiv
    mov count, cx
    ; cx = 3
	;反向输出余数, '123'
Lprint:
    pop ax		   ;取出余数	
    add al, '0'    ; 加'0',转换成asc2码 
    put_char al
    loop  Lprint   

	pop dx ;恢复寄存器环境
	pop cx
	pop bx
	pop ax

    ret
print_int endp
code ends  
end start 
