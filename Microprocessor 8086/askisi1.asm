; multi-segment executable file template.

data segment
    plythos dw 800
    addrn dw 32765 dup(?)
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    mov cx,[plythos]
    mov si,offset addrn
    mov bx,0001h
loopp: mov [si],bx
       inc bx
       inc si
       inc si
       loop loopp
            
    
    mov si,offset addrn
    mov bx,0
    mov ax,0
    mov cx,[plythos]
    mov dx,1
loop2: test [si],dx
       jnz tag1
       add ax,[si]
       adc bx,0
tag1:  inc si
       inc si
       loop loop2
    
    
    
        
    
    ; wait for any key....    
    ;mov ah, 1
   ; int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
