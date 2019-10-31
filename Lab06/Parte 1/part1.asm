.model small
.DATA
    r DB 0FFH DUP(?)                      ;Resultante
    count DB ?
    input DB 'Ingrese una palabra $'
.STACK
.CODE

programa:
    MOV AX,@DATA
    MOV DS, AX
    
    ;Limpieza de pantalla
    MOV AX, 03H
    INT 10H
    
    MOV SI, 0
    MOV count, 0
    
MOV DX, OFFSET input
MOV AH,09H
INT 21h

Read: ;Leer caracteres
    XOR AX,AX
    MOV AH, 01H
    INT 21H
    CMP AL, 0DH
    JZ Print
    MOV r[SI], AL
    INC SI
    INC count
    JMP Read
    
Print:
    ;Limpieza de pantalla
    MOV AX, 03H
    INT 10H
    MOV CL, count
    MOV SI, 0

Aux:
    MOV AH, 02H
    MOV DL, r[SI]
    SUB DL, 20H
    INT 21H
    INC SI
    LOOP Aux
    MOV AH,4CH
    INT 21H             ;Interrupcion del DOS 21H para terminar el programa 
end programa