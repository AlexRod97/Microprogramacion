.model small
.DATA
    r DB 0FFH DUP(?)
    
    count DB ?
    input db 'Ingrese una cadena: $'
    
    NoEsPal db 'No es palindromo $'
    EsPal db 'Si es palindromao $'
.STACK
.CODE

programa:
    MOV AX,@DATA
    MOV DS, AX
    
    MOV SI, 0
    MOV count, 0
    
    MOV DX, OFFSET input
    MOV AH, 09H
    INT 21H
    
Read:

    XOR AX,AX
    MOV AH, 01H
    INT 21H
    CMP AL, 0DH
    JZ Next
    MOV r[SI], AL
    PUSH AX
    INC SI
    INC count
    JMP Read
    
Next:
    MOV SI, 0
    MOV CL, count
    
Check:
    XOR AX,AX
    POP AX
    CMP r[SI], AL
    JNE NotEqual
    INC SI
    LOOP Check
    JMP Equal
    
NotEqual:
    MOV DX, OFFSET NoEsPal
    MOV AH, 09H
    INT 21H
    JMP Terminar
    
Equal:
    MOV DX, OFFSET EsPal
    MOV AH, 09H
    INT 21H
    
Terminar:
    MOV AH,4CH
    INT 21H             ;interrupcion del DOS 21H para finalizar 
    
end programa