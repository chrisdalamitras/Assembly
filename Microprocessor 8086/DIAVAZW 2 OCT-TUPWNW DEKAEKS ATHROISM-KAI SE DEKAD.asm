INCLUDE "MACROS.TXT"

DATA SEGMENT
    MESSAGE1 DB "ENTER A DECIMAL NUMBER:",'$'
    MESSAGE2 DB "HEX:",'$'
    MESSAGE3 DB "OCT:",'$'
    NEWLINE  DB 0AH,0DH,'$'    
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
                                   
READ_OCT_DIGIT PROC NEAR
OCT_DIGIT:
    READ
    CMP AL,30H
    JL  OCT_DIGIT
    CMP AL,37H
    JG  OCT_DIGIT
    SUB AL,30H
    RET
READ_OCT_DIGIT ENDP

; Reads a n-digit oct where n = DL
; Result : BX
; Modifies all registers
; READ_OCT_DIGIT is required

READ_N_DIGIT_OCT PROC NEAR
    MOV BX,0
N_DIGIT_OCT:
    MOV CL,3
    ROL BX,CL
    CALL READ_OCT_DIGIT
    ADD BL,AL
    DEC DL
    CMP DL,00H
    JG  N_DIGIT_OCT
    RET 
READ_N_DIGIT_OCT ENDP    

PRINT_OCT PROC NEAR
    MOV BX,CX
    AND CX,07000H
    ROR CH,1
    ROR CH,1
    ROR CH,1
    ROR CH,1
    ADD CH,30H
    PRINT CH
    MOV CX,BX
    AND CX,0E00H
    ROR CH,1
    ADD CH,30H
    PRINT CH
    MOV CX,BX
    AND CX,01F0H
    ROL CX,1
    ROL CX,1          
    ADD CH,30H
    PRINT CH
    MOV CX,BX
    AND CX,0038H
    ROR CL,1
    ROR CL,1
    ROR CL,1
    ADD CL,30H
    PRINT CL
    MOV CX,BX
    AND CX,07H
    ADD CL,30H
    PRINT CL
    MOV CX,BX
    RET    
PRINT_OCT ENDP   

PRINT_DEC PROC NEAR
    MOV BX,0
    MOV CX,0
LOOP1:
    SUB DX,2710H
    CMP DX,0
    JL  EXIT1
    INC BH
    JMP LOOP1
EXIT1:
    ADD BH,30H
    ADD DX,2710H
LOOP2:
    SUB DX,03E8H
    CMP DX,0
    JL  EXIT2
    INC BL
    JMP LOOP2
EXIT2:
    ADD BL,30H
    ADD DX,03E8H
LOOP3:
    SUB DX,64H
    CMP DX,0
    JL  EXIT3
    INC CH
    JMP LOOP3
EXIT3:     
    ADD CH,30H
    ADD DX,64H
LOOP4:
    SUB DX,0AH
    CMP DX,0
    JL  EXIT4
    INC CL
    JMP LOOP4
EXIT4:
    ADD CL,30H
    ADD DX,0AH
    ADD DX,30H
    CMP BH,30H
    JE  NOT_ALL
    PUSH DX
    PRINT BH
    POP DX
NOT_ALL:
    PUSH DX    
    PRINT BL
    PRINT CH
    PRINT CL
    POP DX
    PRINT DL
    RET
PRINT_DEC ENDP

MAIN PROC FAR
    MOV AX,DATA
    MOV DS,AX
START:
    MOV DH,00
    MOV DL,02H
    CALL READ_N_DIGIT_OCT
    MOV AX,BX
    MOV DX,4000H
    OUT DX,AX
    MOV CX,BX
    CALL PRINT_OCT
READ1:
    READ
    CMP AL,2BH
    JNE READ1
    PRINT AL
    MOV DL,02H
    CALL READ_N_DIGIT_OCT
    MOV AX,BX
    MOV DX,4001H
    OUT DX,AX
    MOV CX,BX
    CALL PRINT_OCT
    PRINT_STR NEWLINE
READ2:
    READ
    CMP AL,0DH
    JNE READ2
PROSTHESH:
    MOV CX,00
    MOV DX,4000H
    IN AX,DX
    MOV AH,00
    MOV CX,AX
    MOV DX,4001H
    IN AX,DX
    MOV AH,00
    ADD CX,AX
    CALL PRINT_OCT
    PRINT_STR NEWLINE
    MOV DX,CX
    CALL PRINT_DEC

    
    

    

    JMP START
ENDING:
    EXIT     
    
CODE ENDS
END MAIN