.model small
.stack 100h

.data
target_month db 12     ; 目标月份，假设是12月
target_day db 9       ; 目标日期，假设是10日
target_hour db 12      ; 目标小时，假设是14点
target_minute db 35    ; 目标分钟，假设是30分

msg db "Hello World$"

.code
start:
    ; 初始化数据段
    mov ax, @data
    mov ds, ax

    ; 无限循环，等待时钟中断或目标时间到达
wait_loop:
    ; 获取当前日期
    mov ah, 2Ah       ; 获取当前日期
    int 21h
    ; 获取当前年份、月份、日
    mov target_day, dl
    mov target_month, dh

    ; 获取当前时间
    mov ah, 2Ch       ; 获取当前时间
    int 21h
    ; 获取当前小时和分钟
    mov target_hour, ch
    mov target_minute, cl

    ; 比较目标时间
    ; 比较年份、月份、日期
    cmp target_month, 12
    jne wait_loop
    cmp target_day, 9
    jne wait_loop

    ; 比较小时、分钟
    cmp target_hour, 12
    jne wait_loop
    cmp target_minute, 41
    jne wait_loop

    ; 时间到了，打印消息
    mov ah, 09h       ; 打印字符串
    lea dx, msg
    int 21h

    ; 程序结束
    mov ah, 4Ch       ; 正常退出
    int 21h

end start
