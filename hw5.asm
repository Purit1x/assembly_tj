.model small
.stack 100h
.data
years db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
      db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
      db '1993','1994','1995'

revenues dd 16,22,382,1356,2390,8000,16000,24486,50065,97479
         dd 140417,197514,345980,590827,803530,1183000
         dd 1843000,2759000,3753000,4649001,5937000

employees dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037
          dw 5635,8226,11542,14430,15257,17800

newline db 13, 10, '$'               ; 换行符，用于逐行显示
buffer db 6 dup(0)                   ; 用于存储转换后的数字字符串

table db 21 dup('year summ ne ?? $')  ; 占位符

.code
main proc
    mov ax, @data
    mov ds, ax

    ; 将years中的年份填充到table中的对应位置
    lea si, [years]
    lea di, [table]

    mov cx, 21
fill_years:
    call copy_year
    add di, 13
    loop fill_years

    ; 打印出table中的内容
    call print_table

    mov ah, 4ch
    int 21h

main endp

; 子程序：复制一个年份到table中
copy_year proc
    mov al, [si]
    mov [di], al
    inc si
    inc di
    
    mov al, [si]
    mov [di], al
    inc si
    inc di
    
    mov al, [si]
    mov [di], al
    inc si
    inc di
    
    mov al, [si]
    mov [di], al
    inc si
    inc di
    ret
copy_year endp

; 子程序：打印table中的内容
print_table proc
    lea si, [table]
    mov cx, 21
print_loop:
    mov dx, si
    mov ah, 09h
    int 21h

    lea dx, [newline]
    int 21h
    add si, 17
    loop print_loop
    ret
print_table endp

end main