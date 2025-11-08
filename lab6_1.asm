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
    
    S1 db 1,3,5,7
    len1 equ $ - S1
    S2 db 2,6,9,4
    len2 equ $ - S2
    
    D resb len1 + len2

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        cld
                             
        mov ecx, len1
        
        mov esi, S1 ; ESI pointeaza la inceputul S1
        mov ebx, S2 ; EBX pointeaza la inceputul S2
        mov edi, D  ; EDI pointeaza la inceputul D
        
        for_loop:
            mov al, [esi] ; al = s1[i]
            mov [edi], al ; il pun in D
            inc esi
            inc edi
            
            mov al, [ebx] ; al = s2[i]
            mov [edi], al ; il pun in D
            inc ebx
            inc edi

            loop for_loop
 
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
