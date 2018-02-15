; multi-segment executable file template.

data segment
    plythos dw 100
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
       mov cx,[plythos] 
       mov ax,0
       mov bx,0

;AX register store the maximum and BX stores the second maximum number    
loop2: mov dx,[si]
       cmp dx,ax
       jbe tag1  ;an mikrotero tou megistou sygkrine to me to 2o megisto                      
       mov bx,ax
       mov ax,dx ;alliws max1=[si] kai max2=palio max1
       jmp tag2                           
tag1:  cmp dx,bx
       jbe tag2
       mov bx,dx
tag2:
       inc si
       inc si
       loop loop2
    
    mov [si],ax
    inc si
    inc si
    mov [si],bx
    
    mov cx,ax    
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
