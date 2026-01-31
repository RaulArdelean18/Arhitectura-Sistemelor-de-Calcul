section .data
	cuvinte dw 0xBEAE, 0xBEAE, 0xBEEB, 0xBEFE, 0xBEAB, 0xBFAE, 0xBFEB
	len_cuvinte equ ($ - cuvinte) / 2
	target_str db "binary", 0
    len_target equ 6

    msg_da db "DA", 10
    len_da equ $ - msg_da

    msg_nu db "NU", 10
    len_nu equ $ - msg_nu

section .bss
    rezultat_octeti resb 100 

section .text
	global _start
	global _reverse

_start:
	xor esi, esi
	xor edi, edi
	mov ecx, len_cuvinte

loop_procesare:
	push ecx
	mov ax, [cuvinte+esi*2]

	call _proc_get_even_bits

	mov [rezultat_octeti + edi], al

	inc edi
	inc esi
	pop ecx
	dec ecx
	jnz loop_procesare

	push len_target
	push target_str
	push len_cuvinte  
	push rezultat_octeti 
	call _proc_search_substring

	add esp, 4*4
	mov eax, 1
	xor ebx, ebx
	ret


_proc_get_even_bits:
    push ebp
    mov ebp, esp
    
    push ebx
    push ecx
    push edx

	xor bl, bl
	xor cx, cx

extract_loop:
    test ax, 1
    jz bit_is_zero
    
    ; Daca bitul este 1, setam bitul CX in registrul BL
    ; Folosim BTS (Bit Test and Set) sau shiftare
    bts bx, cx      ; Seteaza bitul de pe pozitia CX in BX

		