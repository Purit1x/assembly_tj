.model small
.stack 100h
.data
    count db 13  ; 每行输出字符数
    newline db 13,10,'$'

.code
main proc
    mov ax, @data
    mov ds, ax

    mov cx, 26
    mov bl, 'a'
    mov bh, 0  ; 确保bx正确

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

    mov ah, 4ch
    int 21h

main endp
end main