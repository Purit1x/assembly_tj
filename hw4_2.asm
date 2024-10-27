.model small
.stack 100h
.data
    table  db 7,2,3,4,5,6,7,8,9             ;9*9表数据
	  db 2,4,7,8,10,12,14,16,18
	  db 3,6,9,12,15,18,21,24,27
	  db 4,8,12,16,7,24,28,32,36
	  db 5,10,15,20,25,30,35,40,45
	  db 6,12,18,24,30,7,42,48,54
	  db 7,14,21,28,35,42,49,56,63
	  db 8,16,24,32,40,48,56,7,72
	  db 9,18,27,36,45,54,63,72,81
    newline db 13, 10, '$'
	firstline db 'x y','$'

.code
print_error proc
	lea si, [table]
	push ax  ; 先将ax暂存，用于计算(bx - 1) * 9
	mov ax, bx
	dec ax
	push cx  ; 暂存cx
	mov cx, 9
	mul cl
	add si, ax
	pop cx
	pop ax
	add si, cx
	dec si
	xor dx, dx
	mov dl, [si]
	
	cmp ax, dx
	je r
	add bx, '0'
	mov dx, bx
	mov ah, 02h
	int 21h
	sub bx, '0'
	mov dx, ' '
	int 21h
	add cx, '0'
	mov dx, cx
	int 21h
	sub cx, '0'
	lea dx, [newline]
	mov ah, 09h
	int 21h
r:
	ret
print_error endp

main proc
    mov ax, @data
    mov ds, ax

	lea dx, [firstline]
	mov ah, 09h
	int 21h
	lea dx, [newline]
	int 21h

    mov cx, 1
    push cx  ; 栈顶保存行数
    ; 控制行数
outer_loop:
	pop ax
	push ax

	mov cx, 1  ; 列数
inner_loop:
	pop ax
	push ax
	mul cl
	pop bx
	push bx
	; 此时bx为行数, cx为列数
	call print_error
	inc cx
	cmp cx, 10
	jnge inner_loop

	pop ax
	inc ax
	push ax
	cmp ax, 10
	jnge outer_loop

	mov ah, 4ch
	int 21h


    
main endp
end main