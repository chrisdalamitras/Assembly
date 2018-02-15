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


              


        
        
    
    


    



data segment
    eisodos db ?
    msg1 db 0AH,0DH,"dwse enan dekaeksadiko arithmo 0-F me dyo psyfia $"
    msg2 db 0AH,0DH,"binary : $"
    msg3 db 0AH,0DH,"oct : $"
    msg4 db 0AH,0DH,"decimal : $"
    
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
neosarithmos:          ;edw tha apothhkeyetai o arithmos pou eisagoume
    lea si,msg1
    printstring  si
    mov bh,0   
    call READ_HEX 
    mov bl,al
    mov cl,4
    shl bl,cl
    call READ_HEX
    add bl,al   ;twra o bl kataxwrhths exei thn eisodo se dyadikh morfh
    mov [eisodos],bl
    
    
    call PRINT_BIN
    
    call PRINT_OCT
    
jmp neosarithmos
    
; wait for any key....    
    mov ah, 1
    int 21h
    
    
    
    mov ax, 4c00h ; exit to operating system.
    int 21h                          
    






PRINT_OCT proc near
    lea si,msg3
    printstring si
    mov bl,[eisodos]        
         rol bl,1
         rol bl,1
         mov dl,bl
         and dl,03H ;apomonwse ta 2 ligotero shmantika bit
         add dl,'0'
         print dl
    mov cx,2   ;tha ginei o broxos 2 fores epi 3 bit ara 6 bit
octloop: rol bl,1
         rol bl,1
         rol bl,1
         mov dl,bl
         and dl,07H   ;apomonwse ta 3 ligotero shmantika bit
         add dl,'0'
         print dl 
         loop octloop

         ret 
PRINT_OCT endp
         
         
    

 
 
 
 

PRINT_BIN proc near
       lea si,msg2
       printstring si
        
             mov bl,[eisodos]
             mov cx,8
binloop:     mov dl,0
             rol bl,1
             adc dl,'0'
             print dl
             loop binloop 
             ret
           
PRINT_BIN endp

                   


READ_HEX proc near
                
ignore: mov ah,8
        int 21h                  
        cmp al,'0'
        jb ignore
        cmp al,'9'
        ja tag1
        print al
        sub al,'0'
        jmp tag3
tag1:   cmp al,65  ; to gramma A exei kwdiko ascii 65dec
        jb ignore
        cmp al,70  ;to gramma F exei kwdiko ascii 70dec
        ja tag2
        print al
        sub al,55
        jmp tag3
tag2:   cmp al,97  ;to gramma a exei kwdiko ascii 97dec
        jb ignore
        cmp al,102  ;to gramma f exei kwdiko ascii 102dec
        ja ignore
        print al   
        sub al,87
tag3:   
        ret
READ_HEX endp
 

end start ; set entry point and stop the assembler.
