;Se considera urmatoarea problema si solutia propusa(codul sursa). Este solutia corecta?
;Daca considerati ca este necesar, modificati codul pentru a rezolva problema.
;Asigurati-va ca codul se asambleaza fara erori sau advertismente.
;--------------------------------------------------------------------------------------------------
; Se dau cuvantul A si octetul B. Se cere dublucuvantul C:
; bitii 0-2 ai lui C coincid cu bitii 5-7 ai lui B
; bitii 3-7 ai lui C coincid cu bitii 0-4 ai lui A
; bitii 8-9 ai lui C sunt egali cu 1
; bitii 10-15 ai lui C coincid cu bitii 6-11 ai lui A
; bitii 16-31 ai lui C sunt bitii negati lui A
;Sa se calculeze in interpretare cu semn(d-e+g)/f -e*2, unde d-byte, e-word, f=doubleword, g=qword
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dw 1101001010010110b
    b db 10011011b
    c dd 0
    d db 11
    e dw 4
    f dd 5
    g dq 1
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;mov bx,0
        
        ; pasul 1: bitii 0-2 ai lui C coincid cu bitii 5-7 ai lui B
        
        mov ebx, 0 ; vreau sa fie val 0 toata memoria ebx, ma ajuta pe viitor
        mov al, [b] ; al = b, unde b ii byte 
        ;rol al, 5
        ror al, 5 ; al = 0000 0100b, trebuie sa mut in dreapta bitii
        and al, 07h ; 07h = 0000 0111b, masca care setez bitii lui b
        ;and bl,al
        or bl,al ; setez bl cu bitii 0-3 din b, care ii am in al
        
        ; pasul 2: bitii 3-7 ai lui C coincid cu bitii 0-4 ai lui A
        
        mov ax, [a]
        ;shl ax, bx ; trebuie sa deplasez spre stanga 3 biti, nu bx 
        shl ax, 3 
        and ax, 00F8h ; 0000 0000 1111 1000b = 00F8h, ii corect
        or bx, ax ; pun in bx bitii setati din zona 0-4 a lui A, care sunt acuma pe pozitiile 3-7
        
        ;pasul 3: bitii 8-9 ai lui C sunt egali cu 1
        
        or bh, 00000011b ; ii corect, in bh am bitii de la 8 la 15, deci 11 sunt bitii 8 si 9 din bx
        
        ;pasul 4: bitii 10-15 ai lui C coincid cu bitii 6-11 ai lui A
        
        ;mov ax, a ; nu pot accesa astfel a din segment data, eroare
        ; A = 10, B = 11, C = 12 = 8 + 4 = 1100b
        mov ax, [a]
        shl ax, 4
        ;and ax, FC00h ; 1111 1100 0000 0000b
        and ax, 0FC00h ; crapa daca cel mai din stanga octet ii litera, trebuie sa fie o cifra
        or bx, ax
        or [c], ebx ; aici m-a ajutat mov ebx, 0 ca sa imi setez ultimii 4 octeti cu 0
        
        ;pasul 5: bitii 16-31 ai lui C sunt bitii negati lui A
        
        ;movzx eax, dword[a]
        movzx eax, word[a] ; a ii word, nu dword, deci crapa codul
        rol eax, 16; mut in stanga bitii lui a, i mean am putea face si shiftare, doar ca oricum nu ne intereseaza bitii [16,31], deci scapam de ei dupa ce facem and cu masca 0FFFF0000h
        not eax
        and eax, 11111111111111110000000000000000b ; 0FFFF0000h = 1111 1111 1111 1111 0000 0000 0000 0000b, ii corecta linia
        or [c], eax
        
        ;pasul 6: rezolvarea ecuatiei cu semn (d-e+g)/f -e*2, unde d-byte, e-word, f=doubleword, g=qword
        
        ;mov al, word[d]
        mov al, [d] ; d ii byte, nu word, deci crapa codul
        cbw ; din al devine ax cu semn, conversie cu semn
        ;sub al, [e]
        sub ax, [e] ; e ii word, al ii byte, deci crapa codul
        cwde ; ax = eax 
        cdq ; eax = edx:eax 
        add eax, dword[g]
        ;add edx, dword[g+3]
        add edx, dword[g+4] ; sunt 4 octeti intr-un dword, nu 3
        ;idiv [f] ; nu pot face impartirea cu ceva din segment data (sper)
        mov ecx, [f] ; f ii dword, deci convine
        idiv ecx ; edx:eax / ecx =eax = catul, edx = restul ; eax = (d-e+g)/f 
        mov ebx, eax ; ebx = (d-e+g)/f
        
        
        mov ax, 2
        ;mul word[e]
        mov cx, [e]
        imul cx ; inmultire cu semn, dx:ax = ax * cx, unde in cx trebuie sa am wordul e
        
        push dx
        push ax
        pop eax ; din dx:ax il transform in eax, folosind stiva
        
        sub ebx, eax ; in ebx am (d-e+g)/f, in eax am 2*e, deci fac ebx-eax, iar raspunsul final mi in  ebx 
        ; exit(0)
        
        ; d = 11
        ; e = 4
        ; f = 5
        ; g = 1
        ; ec = -7
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
