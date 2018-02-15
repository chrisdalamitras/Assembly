.include "m16def.inc"

.def temp = r16
.def alarm_active = r17
.def first_overflow = r18

 .DSEG
_tmp_: .byte 2
    
; ---- ����� �������� ��������� 

.CSEG
.org 0x0
rjmp main
.org 0x10
rjmp ISR_TIMER1_OVF  ; ����������� ��� ����������� ��� timer1

ISR_TIMER1_OVF:
do_alarm: ; ������ ��������� �� ��� ������ � ������ ������� �������
	sbrs alarm_active, 0 ; �� � ���������� ����� ���������, ��� ������ ������
	ret
	ser temp ; ������ ����� �� LEDS
	out PORTA, temp
	rcall lcd_init
	ldi r24, 'O'
	rcall lcd_data
	ldi r24, 'N'
	rcall lcd_data
	; ��� ����� �� ��������� �������� ���� LCD
	; ��� �� ����� ���� ��� �� �������
forever:
	rjmp forever

; -------------
; WAIT ROUTINES
; -------------
wait_usec:	;roytina pou kathusterei �sec xrhsimopoieitai apo thn wait_msec
	sbiw r24 ,1 
	nop 
	nop 
	nop 
	nop 
	brne wait_usec 
	ret 

wait_msec:	;routina pou kathusterei tosa msec osa h timh twn r25:r24
	push r24 
	push r25 
	ldi r24 , low(998) 
	ldi r25 , high(998) 
	rcall wait_usec 
	pop r25
	pop r24
	sbiw r24 , 1
	brne wait_msec
	ret


; --------
; SCAN ROW
; --------
scan_row:
    ldi r25 ,0x08	  	; ������������ �� �0000 1000�
back_:	
	lsl r25			; �������� �������� ��� �1� ����� ������
	dec r24			; ���� ����� � ������� ��� �������
    brne back_		
	out PORTC ,r25 		; � ���������� ������ ������� ��� ������ �1�
	nop
	nop			; ����������� ��� �� �������� �� ����� � ������ ����������
	in r24 ,PINC		; ����������� �� ������ (������) ��� ��������� ��� ����� ���������
	andi r24 ,0x0f  		; ������������� �� 4 LSB ���� �� �1� �������� ��� ����� ��������� 
	ret			; �� ���������.

; -----------
; SCAN KEYPAD
; -----------

scan_keypad:
    ldi r24 ,0x01   		; ������ ��� ����� ������ ��� �������������
   	rcall scan_row        
swap r24          		; ���������� �� ����������
	mov r27 ,r24    		; ��� 4 msb ��� r27
	ldi r24 ,0x02   		; ������ �� ������� ������ ��� �������������
	rcall scan_row
	add r27 ,r24    		; ���������� �� ���������� ��� 4 lsb ��� r27
    ldi r24 ,0x03     		 ; ������ ��� ����� ������ ��� �������������
    rcall scan_row
	swap r24           		; ���������� �� ����������
	mov r26 ,r24   		; ��� 4 msb ��� r26
	ldi r24 ,0x04     		; ������ ��� ������� ������ ��� �������������
	rcall scan_row
	add r26 ,r24     		; ���������� �� ���������� ��� 4 lsb ��� r26
	movw r24 ,r26 		; �������� �� ���������� ����� ����������� r25:r24
	ret


; ----------------
; SCAN RISING EDGE
; ----------------

scan_keypad_rising_edge:
    mov r22 ,r24            	; ���������� �� ����� ������������ ���� r22   
	rcall scan_keypad       	; ������ �� ������������ ��� ���������� ��������� 
	push r24                	; ��� ���������� �� ����������
	push r25
	mov r24 ,r22            	; ����������� r22 ms (������� ����� 10-20 msec ��� ����������� ��� ��� 
	ldi r25 ,0          		; ������������ ��� ������������� � ������������� ������������)
	rcall wait_msec
	rcall scan_keypad       	; ������ �� ������������ ���� ���
	pop r23                 	; �������� ��� ������� ����������
	pop r22                 	; �����������
	and r24 ,r22            	
	and r25 ,r23
	ldi r26 ,low(_tmp_)     	; ������� ��� ��������� ��� ��������� ����
	ldi r27 ,high(_tmp_)    	; ����������� ����� ��� �������� ����� r27:r26
    ld r23 ,X+                
	ld r22 ,X
	st X ,r24               	; ���������� ��� RAM �� ��� ���������
	st -X ,r25              	; ��� ���������
	com r23                   
	com r22                 	; ���� ���� ��������� ��� ����� ������ �������
	and r24 ,r22           	
	and r25 ,r23
	ret

; ---------------
; KEYPAD TO ASCII
; ---------------

keypad_to_ascii:		; ������ �1� ���� ������ ��� ���������� r26 �������� 
    movw r26 ,r24 		; �� �������� ������� ��� ��������
	ldi r24 ,'*'
	sbrc r26 ,0
	ret
	ldi r24 ,'0'
	sbrc r26 ,1
	ret
	ldi r24 ,'#'
	sbrc r26 ,2
	ret
	ldi r24 ,'D' 
	sbrc r26 ,3		; �� ��� ����� �1������������ ��� ret, ������ (�� ����� �1�) 
	ret			; ���������� �� ��� ���������� r24 ��� ASCII ���� ��� D.
	ldi r24 ,'7'
	sbrc r26 ,4
	ret
	ldi r24 ,'8'
	sbrc r26 ,5
	ret
	ldi r24 ,'9'
	sbrc r26 ,6
	ret
	ldi r24 ,'C'
	sbrc r26 ,7
   	ret
    ldi r24 ,'4'		; ������ �1� ���� ������ ��� ���������� r27 ��������
	sbrc r27 ,0		; �� �������� ������� ��� ��������
	ret
	ldi r24 ,'5'	
	sbrc r27 ,1
	ret
	ldi r24 ,'6'
	sbrc r27 ,2
	ret
	ldi r24 ,'B'
	sbrc r27 ,3
	ret
	ldi r24 ,'1'
	sbrc r27 ,4
	ret
	ldi r24 ,'2'
	sbrc r27 ,5
	ret
	ldi r24 ,'3'
	sbrc r27 ,6
	ret
	ldi r24 ,'A'
	sbrc r27 ,7
	ret
	clr r24
    ret

	
 write_2_nibbles: 
push r24                      ; ������� �� 4 MSB  
 in r25 ,PIND                ; ����������� �� 4 LSB ��� �� �������������
 andi r25 ,0x0f              ; ��� �� ��� ��������� ��� ����� ����������� ���������
 andi r24 ,0xf0              ; ������������� �� 4 MSB ���  
 add r24 ,r25                ; ������������ �� �� ������������ 4 LSB 
 out PORTD ,r24           ; ��� �������� ���� �����
 sbi PORTD ,PD3          ; ������������� ������ �nable ���� ��������� PD3   
cbi PORTD ,PD3           ; PD3=1 ��� ���� PD3=0 
pop r24                      ; ������� �� 4 LSB. ��������� �� byte. 
 swap r24                   ; ������������� �� 4 MSB �� �� 4 LSB 
 andi r24 ,0xf0            ; ��� �� ��� ����� ���� �������������  
add r24 ,r25 
out PORTD ,r24 
sbi PORTD ,PD3           ; ���� ������ �nable 
cbi PORTD ,PD3 
ret 

lcd_data: 
 sbi PORTD ,PD2            ; ������� ��� ���������� ��������� (PD2=1) 
 rcall write_2_nibbles      ; �������� ��� byte 
 ldi r24 ,43                    ; ������� 43�sec ����� �� ����������� � ����
 ldi r25 ,0                       ; ��� ��������� ��� ��� ������� ��� lcd 
 rcall wait_usec 
 ret


  lcd_command: 
cbi PORTD ,PD2           ; ������� ��� ���������� ������� (PD2=1) 
 rcall write_2_nibbles    ; �������� ��� ������� ��� ������� 39�sec 
ldi r24 ,39                   ; ��� ��� ���������� ��� ��������� ��� ��� ��� ������� ��� lcd. 
ldi r25 ,0                     ; ���.: �������� ��� �������, ��  clear display ��� return home,  
rcall wait_usec            ; ��� �������� ��������� ���������� ������� ��������. 
 ret 


lcd_init:     
 ldi r24 ,40                ; ���� � �������� ��� lcd ������������� ��  
 ldi r25 ,0                 ; ����� ������� ��� ���� ��� ������������. 
 rcall wait_msec        ; ������� 40 msec ����� ���� �� �����������. 
 ldi r24 ,0x30            ; ������ ��������� �� 8 bit mode 
 out PORTD ,r24        ; ������ ��� �������� �� ������� �������
 sbi PORTD ,PD3       ; ��� �� ���������� ������� ��� �������
 cbi PORTD ,PD3       ; ��� ������, � ������ ������������ ��� �����
 ldi r24 ,39 
 ldi r25 ,0                   ; ��� � �������� ��� ������ ��������� �� 8-bit mode 
 rcall wait_usec           ; ��� �� ������ ������, ���� �� � �������� ���� ����������
                            ; ������� 4 bit �� ������� �� ���������� 8 bit	
 ldi r24 ,0x30        
 out PORTD ,r24 
 sbi PORTD ,PD3 
 cbi PORTD ,PD3 
 ldi r24 ,39 
 ldi r25 ,0 
 rcall wait_usec  
 ldi r24 ,0x20               ; ������ �� 4-bit mode 
 out PORTD ,r24 
 sbi PORTD ,PD3 
 cbi PORTD ,PD3 
 ldi r24 ,39 
 ldi r25 ,0 
 rcall wait_usec      
                
 ldi r24 ,0x28                 ; ������� ���������� �������� 5x8 ��������
 rcall lcd_command        ; ��� �������� ��� ������� ���� �����
 ldi r24 ,0x0c                 ; ������������ ��� ������,  �������� ��� �������
 rcall lcd_command      
 ldi r24 ,0x01                ; ���������� ��� ������
 rcall lcd_command 
 ldi r24 ,low(1530) 
 ldi r25 ,high(1530) 
 rcall wait_usec     
     
 ldi r24 ,0x06               ; ������������ ��������� ������� ���� 1 ��� ����������  
 rcall lcd_command      ; ��� ����� ������������ ���� ������� ����������� ���    
                                 ; �������������� ��� ��������� ��������� ��� ������
 ret 


main:
	ldi temp, low(RAMEND)
	out spl, temp
	ldi temp, high(RAMEND)
	out sph, temp

	ldi r24 ,0xF0  	; ����� �� ������� �� 4 MSB ��� PORTC ��� �� Keyboard Scan
    out DDRC ,r24
	ser r24	; ������ ��� �� LEDS ��� PORTA
	out DDRA, r24
	clr r24
	out DDRB, r24 ; ��� �� PB �������
	ser r24
	out DDRD,r24

	ldi r24,0xFC
	out PORTD,r24


	;ldi temp,	(1<<ISC01) | (1<<ISC00)	; ������������ ��� INT0 �� ���� ������� �����
	//out MCUCR, temp
	;ldi temp, (0<<INT0) | (0<<INT1)	
	;out GICR, temp
	clr temp
	out MCUCR, temp
	out GICR, temp

	ldi temp, (1<<TOIE1) 	; ������������ �������� ������������ ��� ������� TCNT1
	out TIMSK, temp         ; ��� ��� timer1
	ldi temp, (1<<CS12) | (0<<CS11) | (1<<CS10) ; CK/1024
	out TCCR1B, temp

	sei

	ldi r24,0x0F
	rcall scan_keypad_rising_edge ; Initiallize _tmp_ variable

	rcall lcd_init
	ser r20
	ldi r24,'W'
	rcall lcd_data




read_sensors:
	in temp, PINB
	cpi temp, 0x0C ; FIXME IGNORE LEDS THAT ARE ALREADY OPEN
	breq read_sensors
start_countdown:
	out PORTA, temp
	; Init timer
	ldi r24,0x67         ; ������������ ��� TCNT1 to
	out TCNT1H ,r24    	; ��� ����������� ���� ��� 5 sec
	ldi r24 ,0x69
	out TCNT1L ,r24
	ldi alarm_active, 0x01

read_first:
	ldi r24, 0x0F
	rcall scan_keypad_rising_edge
	rcall keypad_to_ascii
	cpi r24, 0
	breq read_first ; No key was pressed
	cpi r24, '1'	; FIRST DIGIT
	breq read_second
	rjmp activate_alarm
read_second:
	ldi r24, 0x0F
	rcall scan_keypad_rising_edge
	rcall keypad_to_ascii
	cpi r24, 0
	breq read_second ; No key was pressed
	cpi r24, '9'	; SECOND DIGIT
	breq read_third
	rjmp activate_alarm
read_third:
	ldi r24, 0x0F
	rcall scan_keypad_rising_edge
	rcall keypad_to_ascii
	cpi r24, 0
	breq read_third ; No key was pressed
	cpi r24, '1'	; THIRD DIGIT
	breq read_fourth
	rjmp activate_alarm
read_fourth:
	ldi r24, 0x0F
	rcall scan_keypad_rising_edge
	rcall keypad_to_ascii
	cpi r24, 0
	breq read_fourth ; No key was pressed
	cpi r24, '7'	; FOURTH DIGIT
	brne activate_alarm
	ldi alarm_active,0x00 ; �� � ������� ���� ������, �������������� �� ���������
	rcall lcd_init
	ldi r24, 'O'
	rcall lcd_data
	ldi r24, 'F'
	rcall lcd_data
	ldi r24, 'F'
	rcall lcd_data
activate_alarm: ; ������ ������������ �� ���������
	rcall do_alarm
	rjmp read_sensors ; �� ����� return ��� ���� ���� ��������� ��� ���� ��������������� � ���������� ���� ������ � do_alarm
	

	
