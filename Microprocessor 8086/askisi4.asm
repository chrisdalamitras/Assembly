printstring macro addressoffset        ;typwnei string
    mov dx,addressoffset
    mov ah,9
    int 21h
endm

;readchar macro                  ;diabazei xarakthra xwris na ton typwnei
 ;   mov ah,8
  ;  int 21h
;endm

print macro char            ;typwnei thn parametro poy dexetai (8bit)
    mov dl,char
    mov ah,2
    int 21h
endm

   


    



data segment
    prwtos dw ?
    deyteros dw ? 
    ginomeno dw ?
    msg1 db 0AH,0DH,"dwse ton prwto dipshfio dekadiko arithmo: $"
    msg2 db 0AH,0DH,"dwse ton deytero dipshfio dekadiko arithmo: $"
    msg3 db 0AH,0DH,"x= $"
    msg4 db "  y= $"
    msg5 db 0AH,0DH,"pathste ENTER gia synexeia...  $"
    msg6 db 0AH,0DH,"xy= $"
    msg7 db "   x-y= $"
    
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
    
      ;ston bl tha sxhmatizetai o dipshfios arithmos
    call READ_DEC
    mov dl,10
    mul dl   ;pollaplasiazw to al me to 10     
    mov bl,al
    call READ_DEC
    add bl,al
    
    mov bh,0  
    mov [prwtos],bx
    
    lea si,msg2
    printstring  si
    
    
           
    call READ_DEC
    mov dl,10
    mul dl     
    mov bl,al
    call READ_DEC    
    add bl,al      
    
    mov bh,0
    mov [deyteros],bx
    
    
    
    lea si,msg3
    printstring  si
    mov ax,[prwtos]
    call PRINT_DEC
    
    lea si,msg4
    printstring  si
    mov ax,[deyteros]
    call PRINT_DEC
    
    
    lea si,msg5
    printstring  si  
    
    ; wait for enter    
enter:   mov ah, 8
         int 21h
         cmp al,'Q'
         je stop
         cmp al,13
         jne enter
    
    mov bx,[prwtos]
    mov ax,[deyteros]           ;  bl =prwtos  al=deyteros
    mul bl   ; bl*al   kai to apotelesma ston  ah,al
    mov [ginomeno],ax
    lea si,msg6
    printstring  si        
    mov bx,[ginomeno]
    call PRINT_HEX
    
     
    lea si,msg7
    printstring  si 
    mov bx,[prwtos]
    sub bx,[deyteros]
    cmp bl,0
    jge con1
    mov dl,45                ;alliws typwse to proshmo (-)
    print dl
    neg bl
con1: mov bh,0
      call PRINT_HEX
      
    
   
    
jmp neosarithmos
    
; wait for any key....    
    mov ah, 1
    int 21h
    
    
    
stop:   mov ax, 4c00h ; exit to operating system.
        int 21h                          
    

PRINT_HEX proc near         ;typwnei ton arithmo ston kataxwrhth bx
    mov cx,4        
hexloop: rol bx,1
         rol bx,1              
         rol bx,1
         rol bx,1
         mov dx,bx
         and dx,000FH
         call printhex
         loop hexloop
         ret
PRINT_HEX endp

printhex proc near
    cmp dl,9
    jle addr3
    add dl,37h
    jmp addr4
addr3: add dl,30h
addr4: print dl
       ret
printhex endp         
                   





         
PRINT_DEC proc near
                 
    
    
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
          ret      
    
PRINT_DEC endp

    
    
    



READ_DEC proc near
                
ignore: mov ah,8
        int 21h
        cmp al,'Q'
        je stop      ;termatizei an dw8ei Q            
        cmp al,'0'
        jb ignore
        cmp al,'9'
        ja ignore
        print al
        sub al,'0'
   
        ret
READ_DEC endp
 

end start ; set entry point and stop the assembler.
