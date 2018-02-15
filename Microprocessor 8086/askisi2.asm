printstring macro addressoffset        ;typwnei string
    mov dx,addressoffset
    mov ah,9
    int 21h
endm



print macro char            ;typwnei thn parametro poy dexetai (8bit)
    mov dl,char
    mov ah,2
    int 21h
endm


oct_read macro                ;diabazei oktadikous arithmous
ignore: mov ah,8
        int 21h
        cmp al,'Q'            ;termatizei me ton xarakthra Q
        je stop
        cmp al,'0'
        jb ignore
        cmp al,'7'
        ja ignore
        print al
        sub al,'0'
endm

        
        

    



data segment
    eisodos dw ?
    msg1 db "dwse enan oktadiko arithmo 0-7 me tria psyfia $"
    msg2 db 0AH,0DH,"binary : $"
    msg3 db 0AH,0DH,"hexademical : $"
    msg4 db 0AH,0DH,"decimal : $"
    msg5 db 0AH,0DH,"$"
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
    assume cs:code,ds:data
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
neosarithmos:    mov bx,0       
    lea si,msg1
    printstring  si 
    mov cx,3
loop1: oct_read
       mov ah,0
       add bx,ax
       shl bx,1
       shl bx,1
       shl bx,1
       loop loop1
       
                     
       mov cl,3
       shr bx,cl
       mov [eisodos],bx
                  ;twra einai se dyakikh morfh ston bx kataxwrhth
       lea si,msg2
       printstring si
        
    mov cl,7
    shl bx,cl 
             mov cx,9
printbinary: mov dl,0
             shl bx,1
             adc dl,'0'
             print dl
             loop printbinary
    
    
    lea si,msg3
       printstring si
             
    mov cx,4        
    mov bx,[eisodos]
hexloop: rol bx,1
         rol bx,1
         rol bx,1
         rol bx,1
         mov dx,bx
         and dx,000FH
         call printhex
         loop hexloop  
         
         
         
     lea si,msg4
       printstring si        
    
    mov ax,[eisodos]
    mov cx,0
    mov bx,10
    
decloop: mov dx,0
         div bx
         push dx
         inc cx
         cmp ax,0            
         jnz decloop
         
decprint: pop dx
          add dl,'0'
          print dl
          loop decprint      
    
    
        
    lea si,msg5
    printstring  si 
    
    jmp neosarithmos
    
stop:    mov ax, 4c00h ; exit to operating system.
         int 21h                   
    
printhex proc near
    cmp dl,9
    jle addr3
    add dl,37h
    jmp addr4
addr3: add dl,30h
addr4: print dl
       ret
printhex endp
ends

end start ; set entry point and stop the assembler.
