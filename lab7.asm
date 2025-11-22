bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s1 dd 0702090Ah, 0B0C0304h, 05060108h
    len equ 6 ;; 3 dublucuvinte (fiecare cate 2 octeti) => 6 octeti in total
    b times len db 0
    ; ...

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        mov ecx, 3 ; avem 3 dublu cuvinte de operat
        mov esi, s1 ; pun in esi pe s1 
        mov edi, b ; pun in edi pe b 
        cld
        
        bucla1:
        lodsd ; pun in eax dublucuvantul din esi (s1)
        mov ebx, eax ; fac o copie la eax si il pun in ebx

        ; ----------- partea 1 ------------------------
        shr eax, 16 ; 0702090Ah => ax = 0702h     
        shl ah,4 ; ax = 7002h
        or al,ah ; al = 72h
        stosb ; il pun in b pe 72h
        
        ; ----------- partea 2 ------------------------
        mov ax, bx ; pun partea low care am elimninat-o in partea 1, deci o sa am ax = 090Ah
        shl ah, 4 ; ah = 90 => ax = 900Ah
        or al, ah ; al = 9Ah 
        stosb ; il pun in b pe 9Ah 
        
        loop bucla1
        
        ; for(int i=1;i<=n-1;i++)
        ;     for(int j=i+1;j<=n;j++)
        ;         if(v[i]>v[j])
        ;             swap(v[i],v[j]);
        
        mov ecx, len - 1   ; am len-1 pasi in bucla cu i - ul 
        mov ebx, b ; sirul b in ebx

        outer_loop: ; for (i=1;i<=n-1;i++)

            mov edi, ebx        
            mov esi, ebx ; pun in esi pointerul lui b+i
            inc esi ; ii dau increment ca sa fiu pe b+i+1
            mov edx, ecx ; contorul pentru inner_loop, se ruleaza n-i-1 ori

            inner_loop:

                lodsb ; pun in al val din [esi] 
                cmp al, [edi] ; compar al cu [edi]
                
                ; daca v[i]>=v[j] dam continue la operatie, ii dam skip
                jge skip_new_min   

                mov edi, esi  ; edi pointeaza la j+1
                dec edi ; il actualizam sa ramana in j

                skip_new_min:       
                    dec edx ; decrementez nr de pasi pt inner_loop
                    jnz inner_loop ; daca nu am ajuns cu i - ul in n, continuam operatiunea     
                    
                    mov al, [ebx] ; al = v[i]  
                    mov ah, [edi] ; ah = v[j]
                    
                    ; aici dam swap intre v[i] si v[j]
                    mov [ebx], ah       
                    mov [edi], al       
                    
                    inc ebx ; incrementez i - ul            
                    loop outer_loop     
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
