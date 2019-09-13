.MODEL small
.DATA
; Variable que contiene el texto que queremos mostrar
nombre DB 'Alex Rodriguez$'; $ significa el final de la cadena 
carnet DB '1053016$' 
.STACK 
.CODE

Programa:              ; etiqueta de inicio de programa
;inicializar programa
MOV AX, @Data          ; guardando direccion de inicio de 
MOV DS, AX

; Imprimir nombre
MOV DX, OFFSET nombre ;asignando a DX la variable nombre
MOV AH, 09h           ;decimos que se imprimira una cadena
INT 21h               ;ejecuta la interrupcion, imprimira

;Salto de linea
MOV DX, 10            ;10 es el valor ascii del enter
MOV AH,02h            ;decimos que se imprimira una cadena
INT 21h               ;ejecuta la interrupcion, imprimira

; Imprimir carnet
MOV DX, OFFSET carnet ;asignando a DX la variable carnet
MOV AH, 09h           ;decimos que se imprimira una cadena
INT 21h               ;ejecuta la interrupcion, imprimira

; finalizar programa
MOV AH, 4Ch           ; finalizar proceso 
INT 21h               ; ejecuta la interrupcion
END programa