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

read macro 
    mov ah,8
    int 21h
endm



data segment
    temprature dw ?
    eisodos dw ?
   msg1 db 0AH,0DH,"START (Y, N) : $"
   msg2 db 0AH,0DH,"h eisodos prepei na exei th morfh: SXXX opou X opoiadhpote dekaeksadika pshfia:    $"
   msg3 db 0AH,0DH,"PRESS Q TO EXIT OR ENTER NEW TEMPRATURE $"
   msg4 db 0AH,0DH,"ERROR tash panw apo 4 volt $"
   msg5 db 0AH,0DH,"TEMPRATURE =  $"
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

    
    
    
loop3: mov dx,offset msg1
    printstring dx 
    read 
    cmp al,'y'
    jz ekkinhsh
    cmp al,'Y'
    jz ekkinhsh
    cmp al,'n'
    jz  telos
    cmp al,'N'
    jz telos
    jmp loop3 
    
ekkinhsh:     mov dx,offset msg2
                 printstring dx 
    
neosarithmos:  mov dx,offset msg3
                 printstring dx  
    
loop1: mov ah,8
       int 21h
       cmp al,'q'
       jz telos
       cmp al,'Q'
       jz telos
       cmp al,'s'
       jz tag4
       cmp al,'S'
       jz tag4
       jmp loop1
tag4:  print al
       mov bx,0   ;ston bx tha sxhmatistei o tripshfios arithmos
       mov cx,3
loop2: shl bx,1
       shl bx,1
       shl bx,1
       shl bx,1
       call READ_HEX
       mov ah,0
       add bx,ax
       loop loop2
       
       mov [eisodos],bx

      cmp bx,4000
      jbe tag5
      mov dx,offset msg4
      printstring dx
      jmp neosarithmos
tag5: cmp bx,3000
      ja tag6
 ;diairw thn eisodo me to 0,6 wste na parw kai to prwto dekadiko pshfio
      mov ax,10
      mul bx    ;pleon to apotelesma ston dx,ax
      mov bx,6
      div bx
                ;exw ston ax ton zhtoymeno arithmo px 5344 an thermokrasia 534,4
             
      mov [temprature],ax
      jmp cont
       
      
tag6: sub bx,2000
      mov ax,5
      mul bx
      mov [temprature],ax       ;o ax exei to apotelesma


cont:    mov dx,offset msg5
         printstring dx
         call PRINT_DEC              
    
            
  
    
   jmp neosarithmos
    
telos:    mov ax, 4c00h ; exit to operating system.
    int 21h
    
    


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




PRINT_DEC proc near
                 
    
    mov ax,[temprature]
    mov cx,0
    mov bx,10
    
decloop: mov dx,0
         div bx
         push dx
         inc cx
         cmp ax,0            
         jnz decloop 
         
         dec cx    ;wste na typwsoyme thn ypodiastolh prin to teleytaio pshfio
         
decprint: pop dx
          add dl,'0'
          print dl
          loop decprint
          
          print "."
          pop dx
          add dl,'0'
          print dl
          ret      
    
PRINT_DEC endp





        
ends     ;gia to code segment


end start ; set entry point and stop the assembler.
