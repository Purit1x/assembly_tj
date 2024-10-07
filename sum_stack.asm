.model small
.data
    buffer db '     $'
.stack 100h

.code
main proc
    mov ax, @data
    mov ds, ax

    mov cx, 100
    xor ax, ax

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

    lea dx, [buffer]
    mov ah, 09h
    int 21h

    mov ah, 4ch
    int 21h
main endp
end main