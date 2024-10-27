.model small
.stack 100h
.data
    msg db 'The 9mul9 table:', '$'
    newline db 13, 10, '$'
    buffer db 3 dup(0), '$'

.code
convert proc
    mov cx, 10
    lea bx, [buffer]
    add bx, 2
convert_loop:
    xor dx, dx
    div cx
    add dl, '0' 
    mov [bx], dl
    dec bx
    test ax, ax
    jnz convert_loop

    ret
convert endp

clear_buffer proc
    mov si, 3
    lea bx, [buffer]
clear_loop:
    mov [bx] , BYTE PTR 0
    inc bx
    dec si
    jnz clear_loop
    ret
clear_buffer endp

main proc
    mov ax, @data
    mov ds, ax

    mov cx, 9  ; 外层循环计数，控制列数
    push cx
outer_loop:
    pop ax  ; 将本行第一个乘数存至ax, 保证下一次循环前栈顶为第一个乘数
    push ax ; 放回一个复制

    mov cx, 1  ; 内层循环计数，第几列
inner_loop:
    pop dx  ; 将第一个乘数弹栈至dx
    push dx  ; 放回一个复制
    ; 打印第一个乘数
    add dx, '0'
    mov ah, 02h
    int 21h

    ; 打印*
    xor dx, dx
    mov dx, '*'
    mov ah, 02h
    int 21h

    ; 打印第二个乘数
    xor dx, dx
    mov dl, cl
    add dl, '0'
    mov ah, 02h
    int 21h

    xor dx, dx
    mov dx, '='
    mov ah, 02h
    int 21h

    pop ax
    push ax
    mul cl

    push cx  ; 将当前列数压栈
    call convert
    pop cx

    lea dx, [buffer]
    mov ah, 09h
    int 21h

    call clear_buffer

    mov dx, ' '
    mov ah, 02h
    int 21h

    inc cx
    pop bx  ; 将第一个乘数放至bx，用于判断本层是否结束
    push bx
    cmp cx, bx
    jle inner_loop
    
    lea dx, [newline]
    mov ah, 09h
    int 21h

    ; 进入下一层循环
    pop cx
    dec cx
    push cx
    jnz outer_loop    

    mov ah, 4ch
    int 21h
main endp
end main

