.model small
.data
    buffer db 5 dup(0)  ; 存储用户输入
    result db '     $'
    num db 0
    sum dw 0
    newline db 13, 10, '$'
    prompt db 'Enter a number between 1 and 100: $'

.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, prompt
    mov ah, 09h
    int 21h

    ; 读取用户输入
    lea si, buffer + 1
    mov BYTE PTR [buffer], 0  ; 首位存储长度

read_loop:
    mov ah, 1
    int 21h
    cmp al, 13  ; 检查回车
    je input_done
    sub al, '0'

    cmp al, 0
    jl read_loop  ; 检查输入是否合法
    cmp al, 9
    jg read_loop

    mov [si], al  ; 存储当前字符
    inc si  ; 移动到下一个位置
    inc BYTE PTR [buffer]
    cmp BYTE PTR [buffer], 3  ; 最多3位数
    jle read_loop
    jmp input_done

input_done:
    ; 转换输入的数字
    lea si, buffer
    mov cl, [buffer]
    mov bx, 0  ; 存储累加结果
    mov di, 1  ; 乘数
    add si, cx  ; 移动到缓冲区末尾

convert_loop:
    mov al, [si]
    cbw  ; al符号位扩展到ax
    mul di  ; ax = al * di
    add bx, ax
    mov ax, di
    mov dx, 10
    mul dx  ; 更新乘数
    mov di, ax
    dec si
    loop convert_loop
    mov num, bl

    mov cl, num
    mov bx, 0
    mov ax, 1

sum_loop:
    add bx, ax
    inc ax
    loop sum_loop

    lea dx, newline
    mov ah, 09h
    int 21H

    mov ax, bx
    mov cx, 10

    lea bx, [result]
    add bx, 4
cts_loop:
    ; 将结果转换为字符串存储在result中
    xor dx, dx
    div cx
    add dl, '0'
    mov [bx], dl
    dec bx
    test ax, ax
    jnz cts_loop

    lea dx, [result]
    mov ah, 09h
    int 21h

    mov ah, 4ch
    int 21H
main endp
end main

    