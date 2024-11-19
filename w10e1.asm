; 文件名: tongji.asm
; 汇编命令: nasm -f obj tongji.asm
; 链接命令: tlink tongji.obj
; 运行环境: DOSBox 或其他DOS兼容环境

.model small
.stack 100h

.data
message db 'Tongji University', 0 ; 字符串以0结尾
color db 02h ; 绿色（背景色为黑色）

.code
main proc
    ; 初始化数据段
    mov ax, @data
    mov ds, ax

    ; 设置文本模式 80x25, 16色
    mov ax, 03h
    int 10h

    ; 计算字符串的位置
    ; 屏幕宽度为80字符
    ; "Tongji University"长度为17个字符
    ; 中心位置 = (80 - 17) / 2 = 31.5 (取整31)
    mov dh, 12 ; 行数 (25行的一半)
    mov dl, 31 ; 列数

    ; 设置光标位置
    mov bh, 0  ; 页面号
    mov ah, 02h ; BIOS设置光标位置服务
    int 10h

    ; 显示字符串
    lea si, [message] ; 源字符串地址
    mov cx, 17 ; 字符串长度
    mov bl, [color] ; 颜色

print_loop:
    push cx ; 保存CX寄存器的值
    mov al, [si] ; 从SI处加载一个字节到AL
    test al, al ; 检查是否为0（字符串结束）
    jz done ; 如果为0，跳转到结束
    mov cx, 1 ; 只显示一个字符
    mov ah, 09h ; BIOS写字符和属性服务
    int 10h
    inc si ; 增加SI指针
    pop cx ; 恢复CX寄存器的值

    inc dl
    mov bh, 0
    mov ah, 02h
    int 10h
    loop print_loop

done:
    ; 终止程序
    mov ah, 4Ch
    int 21h

main endp

end main