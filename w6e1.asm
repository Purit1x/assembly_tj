.model small
.stack 100h
.data
    count db 13
    newline db 13, 10, '$'
.code
main proc
    xor ax, ax
    mov ax, @data
    mov ds, ax
    xor bx, bx
    mov bl, 'a'
    call print_char
    mov bl, 'n'
    call print_char

    mov ah, 4ch
    int 21h
main endp

print_char proc
    xor cx, cx 
    mov cl, count
print_loop:
    mov dl, bl
    mov ah, 02h
    int 21h
    inc bl
    loop print_loop

    lea dx, newline
    mov ah, 09h
    int 21h

    ret
print_char endp

end main





