.model small
.stack 100h
.data
    buffer db '     $'  ; 存储结果转换得到的字符串
.code
main proc
    mov ax, @data
    mov ds, ax
    xor ax, ax  ; ax用于存储累加和
    mov cx, 1

sum_loop:
    add ax, cx
    inc cx
    cmp cx, 101
    jne sum_loop

    lea bx, [buffer]  ; bx指向缓冲区
    add bx, 5  ; 从缓冲区末尾开始填充
    mov BYTE PTR [bx], '$'
    dec bx

    mov cx, 10  ; 除数
convert_loop:
    xor dx, dx
    div cx
    add dl, '0'  ; 将余数转换为ASCII字符
    mov [bx], dl
    dec bx
    test ax, ax  ; 测试商是否为0
    jnz convert_loop

    lea dx, [buffer]
    mov ah, 09h
    int 21h

    mov ah, 4ch
    int 21h

main endp
end main

