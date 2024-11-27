	.file	"w13e1.c"
	.intel_syntax noprefix
	.text
	.def	printf;	.scl	3;	.type	32;	.endef
	.seh_proc	printf
printf:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 56
	.seh_stackalloc	56
	lea	rbp, 48[rsp]
	.seh_setframe	rbp, 48
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx
	mov	QWORD PTR 40[rbp], rdx
	mov	QWORD PTR 48[rbp], r8
	mov	QWORD PTR 56[rbp], r9
	lea	rax, 40[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	rbx, QWORD PTR -16[rbp]
	mov	ecx, 1
	mov	rax, QWORD PTR __imp___acrt_iob_func[rip]
	call	rax
	mov	rcx, rax
	mov	rax, QWORD PTR 32[rbp]
	mov	r8, rbx
	mov	rdx, rax
	call	__mingw_vfprintf
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 56
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC0:
	.ascii "The number of 'AS' is: %d\12\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 88
	.seh_stackalloc	88
	lea	rbp, 80[rsp]
	.seh_setframe	rbp, 80
	.seh_endprologue
	call	__main
	movabs	rax, 4707177784357770049
	mov	QWORD PTR -32[rbp], rax
	movabs	rax, 5999148004769092435
	mov	QWORD PTR -24[rbp], rax
	movabs	rax, 23434248901050689
	mov	QWORD PTR -19[rbp], rax
	mov	WORD PTR -34[rbp], 21313
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -8[rbp], 0
	jmp	.L4
.L6:
	mov	eax, DWORD PTR -8[rbp]
	cdqe
	movzx	edx, BYTE PTR -32[rbp+rax]
	movzx	eax, BYTE PTR -34[rbp]
	cmp	dl, al
	jne	.L5
	mov	eax, DWORD PTR -8[rbp]
	add	eax, 1
	cdqe
	movzx	edx, BYTE PTR -32[rbp+rax]
	movzx	eax, BYTE PTR -33[rbp]
	cmp	dl, al
	jne	.L5
	add	DWORD PTR -4[rbp], 1
.L5:
	add	DWORD PTR -8[rbp], 1
.L4:
	mov	eax, DWORD PTR -8[rbp]
	movsx	rbx, eax
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	strlen
	sub	rax, 1
	cmp	rbx, rax
	jb	.L6
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	lea	rax, .LC0[rip]
	mov	rcx, rax
	call	printf
	mov	eax, 0
	add	rsp, 88
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 13.2.0"
	.def	__mingw_vfprintf;	.scl	2;	.type	32;	.endef
	.def	strlen;	.scl	2;	.type	32;	.endef
