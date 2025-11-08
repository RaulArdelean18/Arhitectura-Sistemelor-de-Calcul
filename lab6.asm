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
    
    S1 db 1,2,3,4
    len1 equ $ - S1
    S2 db 5,6,7
    len2 equ $ - S2
    
    D resb len1 + len2

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        cld  ; DF = 0 
        
        mov ecx, len1 
        mov esi, S1 
        mov edi, D
        
        rep movsb ; facem de ecx ori movsb, care copiaza cate un octet din esi si pune in edi 
                  ; incrementeaza automat esi si edi
                  
        ; D = S1 , EDI pointeaza la len1 pozitii la dreapta, deci o sa fie pe D + len1
        ; ESI pointeaza la S1 + len1, adica a ajuns la finalul listei initiale
        
        
        mov ecx, len2 
        mov esi, S2 ; esi = S2 
        add esi, len2 ; esi = S2 + len2
        dec esi ; esi = S2 + len2 - 1, adresa ultimului element
        
        ;edi este deja la D+len1 din rep movsb
        
        for_loop_S2:
            mov al, [esi] ; luam cate un octet din esi, mergem din dreapta in stanga
            mov [edi], al ; il punem in EDI 
            dec esi ; scadem pointerul din esi 
            inc edi ; crestem pointerul din edi 
            
            loop for_loop_S2 ; dec ECX. daca ECX!=0 => jmp for_loop_S2:
            
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
