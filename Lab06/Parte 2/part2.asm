.model small
.DATA
    r DB 0FFH DUP(?)                      
    r1 DB 0FFH DUP(?)      
    
    count DB ?
    count2 DB ?
    
    input db 'Ingrese la primera cadena: $'
    input2 db 'Ingrese la segunda cadena: $'

    NoIgual db 'Las cadenas no son iguales $'
    Igual db 'Las cadenas si son iguales $'
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
    INC SI
    INC count
    JMP Read
    
Next:
    MOV count2, 0
    MOV SI, 0

    MOV DX, OFFSET input2 
    MOV AH, 09H
    INT 21H

Read2:
    XOR AX,AX
    MOV AH, 01H
    INT 21H
    CMP AL, 0DH
    JZ Terminar
    MOV r1[SI], AL
    INC SI
    INC count2
    JMP Read2
    
Terminar:
    MOV AL, count
    CMP count2, AL
    JNE NotEqual
    MOV SI, 0
    MOV CL, count
    
Check:
    MOV AL, r1[SI]
    CMP r[SI], AL
    JNE NotEqual
    LOOP Check
    JMP Equal
    
NotEqual:
    MOV DX, OFFSET NoIgual
    MOV AH, 09H
    INT 21H
    JMP Fin
    
Equal:
    MOV DX, OFFSET Igual
    MOV AH, 09H
    INT 21H
    
Fin:
    ;Terminar programa
    MOV AH,4CH
    INT 21H             ;interrupcion del DOS para finalizar 
end programa