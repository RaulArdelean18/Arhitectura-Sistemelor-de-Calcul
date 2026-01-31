bits 32

section .text
    global _maxim

_maxim:
    push ebp
    mov ebp, esp
    push ebx ; v
    push esi ; n
    ; v[] si n
    mov esi, [ebp+8]
    mov ecx, [ebp+12]
    test ecx, ecx 
    jle .zero ; i mean, tot timpul ii zero, but sa fiu safe

    mov eax, [esi] ; maxim curent
    mov ebx, 1

.loop:
    cmp ebx, ecx
    jge .done ; daca am parcurs tot vectorul de frecventa, im out
    mov edx, [esi + ebx*4] ; edx = v[ebx]
    cmp edx, eax ; compar edx cu eax
    jle .next
    mov eax, edx ; daca eax ii mai mic, il pun pe edx in eax
.next:
    inc ebx ; incrementez indexul
    jmp .loop

.zero:
    xor eax, eax ; dau reset la eax, unde in eax am nr maxim de caractere speciale puse intr-un cuvant

.done:
    ;restaurez stiva
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
