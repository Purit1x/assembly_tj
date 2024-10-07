.model small
.stack 100h
.data
    count db 13
    newline db 13,10,'$'

.code
main proc
    mov ax, @data
    mov ds, ax

    mov cx, 26
    mov bl, 'a'
    mov bh, 0

output_part:
    mov ah, 02h 
    mov dl, bl
    int 21h

    dec cx
    dec count  ; 输出一个字符cx--,count--
    jnz no_newline
    mov ah, 09h
    lea dx, newline
    int 21h
    mov count, 13

no_newline:
    inc bl
    jcxz end_part
    jmp output_part  ; 还有要输出的部分

end_part:
    mov ah, 4ch
    int 21h

main endp
end main
    