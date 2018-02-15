.include "m16def.inc"

STACK_SET

.def Register=r16

stack_set:
		ldi Register,HIGH($25F)
		out SPH,Register
		ldi Register,LOW($25F)
		out SPL,Register

		
/****************************************************************************************************/


PORTS_SET

.def ports=r17

ports_set:
		ldi ports,0b00000000 ;EISODOI
		out DDRD,ports
		out DDRB,ports

		ldi ports,0b11111111 ;EKSODOI
		out DDRC,ports 
		out DDRA,ports 
		
		
/****************************************************************************************************/


INTERRUPT 0

.org 0x0
jmp reset
.org 0x2
jmp ISR0

reset: 
ldi r24 ,( 1 << ISC01) | ( 1 << ISC00)
out MCUCR , r24
ldi r24 ,( 1 << INT0)
out GICR , r24
sei


/****************************************************************************************************/
		
INTERRUPT 1

.org 0x0
jmp int_set
.org 0x4
jmp ISR1


int_set: 
	ldi r24 ,( 1 << ISC11) | ( 1 << ISC10)
	out MCUCR , r24
	ldi r24 ,( 1 << INT1)
	out GICR , r24
	sei	


/****************************************************************************************************/

MAKE_ROR

.def tempror=r18
.def inror=r19

make_ror:
		
		mov tempror,inror
		andi inror,0b00000001
		cpi inror,1
		brcs make_ror_zero
		jmp make_ror_one

make_ror_zero:
		mov inror,tempror
		lsr inror
		jmp make_ror_exit

make_ror_one:
		mov inror,tempror
		lsr inror
		ori inror,0b10000000

make_ror_exit:
		ret	
		
/****************************************************************************************************/		

CREATE_ABCDEFGH

.def A=r22
.def B=r23
.def C=r26
.def D=r27
.def E=r28
.def F=r29
.def G=r30
.def H=r31

create_ABCDEFGH:

	;A

	in input,PINA
	andi input,0b00000001
	mov A,input


	;B

	in input,PINA
	andi input,0b00000010
	mov inror,input
	call make_ror
	mov input,inror
	mov B,input



	;C

	in input,PINA
	andi input,0b00000100
	mov inror,input
	call make_ror
	call make_ror
	mov input,inror
	mov C,input



	;D

	in input,PINA
	andi input,0b00001000
	mov inror,input
	call make_ror
	call make_ror
	call make_ror
	mov input,inror
	mov D,input



	;E

	in input,PINA
	andi input,0b00010000
	mov inror,input
	call make_ror
	call make_ror
	call make_ror
	call make_ror
	mov input,inror
	mov E,input

	;F

	in input,PINA
	andi input,0b00100000
	mov inror,input
	call make_ror
	call make_ror
	call make_ror
	call make_ror
	call make_ror
	mov input,inror
	mov F,input

	;G

	in input,PINA
	andi input,0b01000000
	mov inror,input
	call make_ror
	call make_ror
	call make_ror
	call make_ror
	call make_ror
	call make_ror
	mov input,inror
	mov G,input

	
	;H

	in input,PINA
	andi input,0b10000000
	mov inror,input
	call make_ror
	call make_ror
	call make_ror
	call make_ror
	call make_ror
	call make_ror
	call make_ror
	mov input,inror
	mov H,input


	ret