;Se considera urmatoarea problema si solutia propusa(codul sursa). Este solutia corecta?
;Daca considerati ca este necesar, modificati codul pentru a rezolva problema.
;Asigurati-va ca codul se asambleaza fara erori sau advertismente.
;--------------------------------------------------------------------------------------------------
; Se dau cuvantul A si octetul B. Se cere dublucuvantul C:
; bitii 0-2 ai lui C coincid cu bitii 5-7 ai lui B
; bitii 3-7 ai lui C coincid cu bitii 0-4 ai lui A
; bitii 8-9 ai lui C sunt egali cu 1
; bitii 10-15 ai lui C coincid cu bitii 6-11 ai lui A
; bitii 16-31 ai lui C sunt bitii coincid cu bitii negati lui A
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
    d db 10
    e dw 3
    f dd 4
    g dq 2
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ebx,0
        mov al, [b]
        ;ror al, 2
        ror al, 5
        and al, 07h ; 0000 0111b
        or  bx,ax ; bx = 0000 0000 0000 0111b
        mov ax, [a] ; 1101 0010 1001 0110b
        
        shl ax, 3 ; 1001 0100 1011 0000b
        and ax, 0000000011111000b ; 0000 0000 1011 0000 b
        or bx, ax ; bx = 0000 0000 1011 0111b
        
        or bh, 03h ; 0000 0011 0000 0000 b
        ; bx = 0000 0011 1011 0111b
        mov ax, [a]
        shl ax, 4
        and ax, 1111110000000000b ; 0010100000000000b
        or bx, ax ; 0010 1011 1011 0111b
        or [c], ebx ; [c]=ebx
        ;movzx eax, dword[a]
        movzx eax, word [a]
        rol eax, 16
        not eax
        and eax, 0FFFF0000h
        or [c], eax
        
        ;(d-e+g)/f -e*2 signed
        ;d-byte, e-word, f=doubleword, g=qword
        mov al, [d]
        cbw 
        sub ax, [e]
        ;cwd
        cwde
        cdq
        ;add eax, dword[g]
        ;add edx, dword[g+2]
        add eax, dword [g]
        adc edx, dword [g+4]
        ;idiv [f]
        mov ecx, [f]
        idiv ecx ; eax = catul, edx = restul ; eax = (d-e+g)/f
        mov ebx, eax ; ebx = (d-e+g)/f
        ;mov al, 2
        mov ax, 2
        mov cx, [e]
        imul cx ; dx:ax=2*e
        push dx
        push ax
        ;pop al
        pop eax
        sub ebx, eax
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program