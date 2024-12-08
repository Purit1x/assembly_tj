.model small
.stack 100h
.data
    mcb_info db 'Flag: $'
    next_mcb_info db ', Next MCB: $'
    psp_info db ', PSP: $'
    size_info db ', Size: $'
    new_line db 13, 10, '$'
    debug_msg db 'Current BX: $'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Start from the first MCB at segment address 0x9FC0
    mov bx, 09FC0h

print_mcb:
    ; Print debugging information for current BX
    mov ah, 09h
    lea dx, debug_msg
    int 21h
    mov ax, bx
    call print_hex_word
    mov ah, 09h
    lea dx, new_line
    int 21h

    ; Set ES to the current MCB segment
    mov es, bx

    ; Print flag byte
    mov ah, 09h
    lea dx, mcb_info
    int 21h

    mov al, es:[0]
    call print_hex_byte

    ; Print next MCB segment address
    mov ah, 09h
    lea dx, next_mcb_info
    int 21h

    mov ax, es:[1]
    call print_hex_word

    ; Print PSP segment address
    mov ah, 09h
    lea dx, psp_info
    int 21h

    mov ax, es:[3]
    call print_hex_word

    ; Print memory block size
    mov ah, 09h
    lea dx, size_info
    int 21h

    mov ax, es:[5]
    call print_hex_word

    ; Print new line
    mov ah, 09h
    lea dx, new_line
    int 21h

    ; Check if this is the last MCB ('Z')
    cmp al, 'Z'
    je end_program

    ; Move to the next MCB
    mov bx, es:[1]  ; Get the segment address of the next MCB

    ; Check if the next MCB segment address is valid
    cmp bx, 0
    je end_program

    jmp print_mcb

end_program:
    ; Exit program
    mov ah, 4Ch
    int 21h

; Function to print a hex byte
print_hex_byte proc
    push ax
    push cx
    mov cx, 0004h
    shr al, cl
    call print_nibble
    pop cx
    pop ax
    and al, 000Fh
    call print_nibble
    ret
print_hex_byte endp

; Function to print a hex word
print_hex_word proc
    push ax
    push cx
    mov cx, 0008h
    shr ax, cl
    call print_hex_byte
    pop cx
    pop ax
    call print_hex_byte
    ret
print_hex_word endp

; Function to print a single nibble as a hex character
print_nibble proc
    add al, 0030h
    cmp al, 003Ah
    jb .print_char
    add al, 0007h
.print_char:
    mov ah, 000Eh
    int 10h
    ret
print_nibble endp

end main