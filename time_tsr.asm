INT_VECTOR=1Ch
bcd_to_bin macro
    ; 输入：bL=BCD码 输出：bH=二进制
    push ax
    push cx
    push dx

    push bx
    mov dl, 0F0h
    and bl, dl
    mov cl, 4
    shr bl, cl  ; 获得十位

    xor ax, ax
    mov al, bl
    mov dl, 10
    mul dl  ; 此时ax中存放十位数字*10
    pop bx

    mov dl, 0Fh
    and bl, dl ; 获得个位数字
    add al, bl
    mov bh, al

    pop dx
    pop cx
    pop ax
endm

code segment
    assume cs:code, ds:code
begin:
    jmp install
old_int dd ? ; 保存原中断向量


new_int_1c proc near
    sti
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es
    pushf
    call dword ptr cs:old_int  ; 调用原中断

    jne next
    jmp exit

next:
    mov ah, 04h
    int 1Ah  ; 获取系统日期

test1:
    mov bl, dh
    bcd_to_bin
    cmp bh, 12  ; 指定月份
    je test2
    jmp exit
test2:
    mov bl, dl
    bcd_to_bin
    cmp bh, 10  ; 指定日
    je test3
    jmp exit
test3:
    mov ah, 02h
    int 1Ah

    mov bl, ch
    bcd_to_bin
    cmp bh, 15  ; 指定小时
    je test4
    jmp exit
test4:
    mov bl, cl
    bcd_to_bin
    cmp bh, 40  ; 指定分钟
    je print_s
    jmp exit
print_s:
    mov ah, 2
    mov dh, 12
    mov dl, 40
    mov bh, 0  ; 页号为0
    int 10h

    ; 打印消息
    mov ah, 0Eh
    mov al, 'H'
    int 10h
    mov al, 'e'
    int 10h
    mov al, 'l'
    int 10h
    mov al, 'l'
    int 10h
    mov al, 'o'
    int 10h
    mov al, '!'
    int 10h
done:
    ; 恢复中断向量
    mov ah, 25h
    mov al, INT_VECTOR
    mov ds, word ptr cs:old_int+2
    mov dx, word ptr cs:old_int
    int 21h
    mov ax, 4c00h

    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    int 21h

exit:
    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    iret
new_int_1c endp

install proc near
    xor ax, ax
    mov es, ax
; 初始化ES段寄存器为0， 指向中断向量表
    mov ax, word ptr es:[INT_VECTOR*4]  ; 获取旧中断向量低字
    mov word ptr cs:old_int, ax         ; 保存到old_int

    mov ax, word ptr es:[INT_VECTOR*4+2]  ; 获取旧中断向量高字
    mov word ptr cs:old_int+2, ax

    mov ah, 25h
    mov al, INT_VECTOR
    push cs
    pop ds
    mov dx, offset new_int_1c
    int 21h

    mov ax, 3100h
    mov dx, offset install
    add dx, 100h

    mov cl, 4
    shr dx, cl
    inc dx
    int 21h

install endp

code ends
end begin