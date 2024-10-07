.model small
.data
    buffer db '     $'
    result dw 0

.code
main proc
    mov ax, @data
    mov ds, ax
    xor ax, ax
    mov cx, 1

sum_loop:
    add [result], cx
    inc cx

    cmp cx, 101
    jne sum_loop

    lea bx, [buffer]
    add bx, 5
    mov BYTE PTR [bx], '$'
    dec bx

    mov ax, [result]
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
    int 21H

main endp
end main