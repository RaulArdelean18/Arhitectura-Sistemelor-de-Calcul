bits 32

section .text
    global _caracter
    extern _putchar

_caracter:
    push ebp
    mov ebp, esp
    ;; le salvez pt ca o sa le folosesc
    push ebx
    push esi
    push edi
    
    ; const char *word, char s, int m, int p 
    ; aici o sa am cuvantul (word din apel)
    mov esi, [ebp+8]

    ; reset la 0 ecx si edx 
    xor ecx, ecx ; contor de pozitie
    xor edx, edx ; contor de vocala

.len_loop:
    mov al, [esi] ; iau caracterul curent
    test al, al ; verific daca nu sunt in capat de cuvant
    jz .len_done ; daca sunt, im out din loop
    inc ecx ; incrementez nr de caractere din cuvant

    mov bl, al ; copie la caracter
    or bl, 0x20 ; scad -32 ca sa fac literele mari sa fie litere mici

    ; verific daca caracterul ii vocala
    cmp bl, 'a'
    je .mark ; daca ii vocala, il marchez
    cmp bl, 'e'
    je .mark
    cmp bl, 'i'
    je .mark
    cmp bl, 'o'
    je .mark
    cmp bl, 'u'
    jne .next
.mark:
    mov dl, 1 ; dl devine true, deci am vocale
.next:
    inc esi ; trec la urmatorul caracter si repet loop ul pana cand ajung la capatul cuvantului
    jmp .len_loop

.len_done:
    mov eax, [ebp+16] ; m, nr de litere pe care trebuie sa aiba cuvantul
    cmp dl, 1 ; verific sa vad daca chiar am vocale
    jne .insert_case ; daca nu am vocale, ma bag sa adaug caracterul special intre fiecare caracter
    cmp ecx, eax ; compar sa vad lungimea cuvantului daca este egala cu m
    jne .insert_case ; daca nu, again


    ; aici adaug caracterul special doar pe pozitia p
    mov esi, [ebp+8] ; pointer la inceputul cuvantului
    mov ebx, [ebp+12] ; caracterul special
    xor edi, edi ; contor cuvinte

.rep_loop:
    mov al, [esi] ; ia caracterul de pe pozitia [esi + edi]
    test al, al ; again verific daca nu am terminat cu cuvantul
    jz .rep_done ; daca am terminat, im out
    inc edi ; incrementez nr de litere
    cmp edi, [ebp+20] ;  verific sa vad daca sunt pe pozitia p
    jne .rep_print_orig ; daca nu sunt pe pozitia p, afisez doar caracterul
    push ebx ; daca nu, pun caracterul special
    call _putchar
    add esp, 4
    jmp .rep_next
.rep_print_orig:
    movzx edx, al ; pun in edx pe al
    push edx ; aici il afisez pe al
    call _putchar
    add esp, 4
.rep_next:
    inc esi ; incrementez pozitia
    jmp .rep_loop

.rep_done:
    push dword ' ' ; pun spatiu ca sa fie frumix in output
    call _putchar
    add esp, 4
    mov eax, 1 ; pun in eax 1, pt ca am pus doar un caracter special
    jmp .ret

.insert_case:
    mov esi, [ebp+8] ; sirul word
    mov ebx, [ebp+12] ; caracterul special
    xor edi, edi ; reset la 0 edi

.ins_loop:
    mov al, [esi]
    test al, al ; daca sunt in capat, im out
    jz .ins_done
    movzx edx, al
    ; afisez caracterul
    push edx
    call _putchar
    add esp, 4
    ; afisez caracterul special
    push ebx
    call _putchar
    add esp, 4
    inc edi
    inc esi
    jmp .ins_loop

.ins_done:
    ; afisez ' ' ca sa fie frumix
    push dword ' '
    call _putchar
    add esp, 4
    mov eax, edi

.ret:
    ; restaurez stiva
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
