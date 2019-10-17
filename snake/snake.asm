.model small
.data   

izq equ 0
arb equ 2
fil equ 20
col equ 30
der equ izq+col
abajo equ arb+fil

       
    TITULO db "PROYECTO NO.1 MICROPROGRAMACION",0
    Menu db 0AH,0DH,"Presione dos veces una tecla para continuar$"
    msjSalida db "Perdiste!",0
    msjPerdiste db "Perdiste!", 0
    punteo db "Punteo: ",0
    cabeza db 'U',10,10
    cuerpo db '?',10,11, 3*15 DUP(0)
    contSegmentos db 1
    valFruta db 1
    ejeXfruta db 20
    ejeYfruta db 20
    gameover db 0
    salir db 0   
    tmpDelay db 5


.stack
    dw   128  dup(0)

.code

main proc far
    mov ax, @data
    mov ds, ax 

    mov ax, 0b800H
    mov es, ax
    
    ;Limpiar la pantalla
    mov ax, 0003H
    int 10H
    
    ;Mandar a llamar titulo
    lea bx, TITULO
    mov dx,00
    call escribirEn ;Llama la escritur de un valor
    
    lea dx, Menu
    mov ah, 09H
    int 21h
    
    mov ah, 07h
    int 21h
    mov ax, 0003H
    int 10H
    call printbox      
    
    
MasterLoop:      
    call delay                 
    lea bx, TITULO
    mov dx, 00
    call escribirEn
    call shiftsnake
    cmp gameover,1
    je gameover_Masterloop
    
    call keyboardfunctions
    cmp salir, 1
    je salirpressed_mainloop
    call generarFruta
    call draw
    
    ;TODO: revisar gameover y salir
    
    jmp Masterloop
    
gameover_MasterLoop:
    mov ax, 0003H
    int 10H
    mov tmpDelay, 100
    mov dx, 0000H
    lea bx, msjPerdiste
    call escribirEn
    call delay    
    jmp salir_mainloop    
    
salirpressed_mainloop:
    mov ax, 0003H
    int 10H    
    mov tmpDelay, 100
    mov dx, 0000H
    lea bx, msjSalida
    call escribirEn
    call delay    
    jmp salir_mainloop    

    
    

salir_mainloop:
;primer metodo de limpiar pantalla
mov ax, 0003H
int 10h    
mov ax, 4c00h
int 21h  

         

;Tiempo de espera utilizando 1Ah
delay proc
    mov ah, 00
    int 1Ah
    mov bx, dx
    
jmp_delay:
    int 1Ah
    sub dx, bx   
    cmp dl, tmpDelay                                                      
    jl jmp_delay    
    ret    
delay endp   


generarFruta proc

    mov ch, ejeYfruta
    mov cl, ejeXfruta

regenerar:
    
    cmp valFruta, 1
    je ret_valFruta
    mov ah, 00
    int 1Ah
    ;dx contains the ticks
    push dx
    mov ax, dx
    xor dx, dx
    xor bh, bh
    mov bl, fil
    dec bl
    div bx
    mov ejeYfruta, dl
    inc ejeYfruta
    
    
    pop ax
    mov bl, col
    dec dl
    xor bh, bh
    xor dx, dx
    div bx
    mov ejeXfruta, dl
    inc ejeXfruta
    
    cmp ejeXfruta, cl
    jne nevermind
    cmp ejeYfruta, ch
    jne nevermind
    jmp regenerar 
            
nevermind:

    mov al, ejeXfruta
    ror al,1
    jc regenerar
    
    
    add ejeYfruta, arb
    add ejeXfruta, izq 
    
    mov dh, ejeYfruta
    mov dl, ejeXfruta
    call readcharat
    cmp bl, '?'
    je regenerar
    cmp bl, '^'
    je regenerar
    cmp bl, '<'
    je regenerar
    cmp bl, '>'
    je regenerar
    cmp bl, 'v'
    je regenerar    
    
ret_valFruta:
    ret
generarFruta endp


dispdigit proc

    add dl, '0'
    mov ah, 02H
    int 21H
    ret
dispdigit endp   

   
dispnum proc    
    test ax,ax
    jz retz
    xor dx, dx
    ;ax contiene el numero que sera mostrado   
    mov bx,10
    div bx
    ;dispnum ax primero
    push dx
    call dispnum  
    pop dx
    call dispdigit
    ret

retz:

    mov ah, 02  
    ret    
dispnum endp   



;coloca la posicion del cursor donde dh=fil, dl = column
setcursorpos proc
    mov ah, 02H
    push bx
    mov bh,0
    int 10h
    pop bx
    ret
setcursorpos endp

draw proc
    lea si, cabeza

draw_loop:

    mov bl, ds:[si]
    test bl, bl
    jz out_draw
    mov dx, ds:[si+1]
    call writecharat
    add si,3   
    jmp draw_loop 

out_draw:

    mov bl, 'X'
    mov dh, ejeYfruta
    mov dl, ejeXfruta
    call writecharat
    mov valFruta, 1
    
    ret
draw endp



;dl contiene el caracter ascii si la tecla se presiona, sino es cero
readchar proc
    mov ah, 02H
    int 16H
    jnz teclaPresionada
    xor dl, dl
    ret

teclaPresionada:
    ;limpia el buffer
    mov ah, 00H
    int 16H
    mov dl,al
    ret
readchar endp                    


;Teclado de movimiento de la serpiente
keyboardfunctions proc
    call readchar
    cmp dl, 0
    je next_14
    
    ;Arriba
    cmp dl, 'w'
    jne next_11
    cmp cabeza, 'U'
    je next_14
    mov cabeza, 'O'
    ret

;Abajo
next_11:
    cmp dl, 's'
    jne next_12
    cmp cabeza, 'O';Como cabeza hay una O
    je next_14
    mov cabeza, 'U' ; Como cabeza hay una U
    ret

;Izquierda
next_12:
    cmp dl, 'a'
    jne next_13
    cmp cabeza, 'D' ;Como cabeza hay una D
    je next_14
    mov cabeza, 'C' ;Como cabeza hay una C
    ret

;Derecha
next_13:
    cmp dl, 'd'
    jne next_14
    cmp cabeza, 'C' ;Como cabeza hay una C
    je next_14
    mov cabeza,'D' ;Como cabeza hay una D

;Salir de la funcion del teclado
next_14:    
    je salir_keyboardfunctions
    ret    

salir_keyboardfunctions:   
    ;Salir del metodo para escuchar teclas
    inc salir
    ret
    
keyboardfunctions endp
                    
                    
shiftsnake proc     
    mov bx, offset cabeza
    
    ;determine the where should the cabeza go solti?
    ;preserve the cabeza

    xor ax, ax
    mov al, [bx]
    push ax
    inc bx
    mov ax, [bx]
    inc bx    
    inc bx
    xor cx, cx
l:      
    mov si, [bx]
    test si, [bx]
    jz outside
    inc cx     
    inc bx
    mov dx,[bx]
    mov [bx], ax
    mov ax,dx
    inc bx
    inc bx
    jmp l
    
outside:    
    
    ;mover la cabeza en la direccion correcta
    ;No se limpia el segmento si encontro fruta

    ;Saca un valor de la pila
    pop ax
    
    ;Inserta un valor en la pila
    push dx
        
    lea bx, cabeza
    inc bx
    mov dx, [bx]
    
    cmp al, 'C'
    jne next_1
    dec dl
    dec dl
    jmp finish_cabeza

next_1:

    cmp al, 'D'
    jne next_2                
    inc dl 
    inc dl
    jmp finish_cabeza
    
next_2:

    cmp al, 'O'
    jne next_3 
    dec dh               
                   
    
    jmp finish_cabeza
    
next_3:

    ;must be 'U'
    inc dh
    
finish_cabeza:    

    mov [bx],dx
    ;Verifica la nueva posicion de la cabeza 
    call readcharat 
    cmp bl, 'X'
    je i_ate_fruit
    
    ;Si no encontr? una fruta, limpi 
    ;it will be cleared where?
    mov cx, dx
    pop dx 
    cmp bl, '@'    ;Si encuentra este valor que no puede 'comer' entonces termina
    je game_over
    cmp bl, '?'    ;Si la serpiente se come a si misma, termina
    je game_over
    mov bl, 0
    call writecharat
    mov dx, cx
    
    ;Verifica si la serpiente esta dentro del campo delimitado por el mapa
    cmp dh, arb
    je game_over
    cmp dh, abajo
    je game_over
    cmp dl,izq
    je game_over
    cmp dl, der
    je game_over
    ret

;Si termina salta aqui    
game_over:

    inc gameover
    ret

;Si comio fruta se va aqui
i_ate_fruit:    

    mov al, contSegmentos
    xor ah, ah
    
    lea bx, cuerpo
    mov cx, 3
    mul cx
    
    pop dx
    add bx, ax
    mov byte ptr ds:[bx], '?'
    mov [bx+1], dx
    inc contSegmentos 
    mov dh, ejeYfruta
    mov dl, ejeXfruta
    mov bl, 0
    call writecharat
    mov valFruta, 0   
    ret 
shiftsnake endp


;Printbox
printbox proc
;Draw a box around
    mov dh, arb
    mov dl, izq
    mov cx, col
    mov bl, '@'

l1:                 
    call writecharat
    inc dl
    loop l1
    
    mov cx, fil

l2:

    call writecharat
    inc dh
    loop l2
    
    mov cx, col
l3:

    call writecharat
    dec dl
    loop l3

    mov cx, fil   
  
l4:

    call writecharat    
    dec dh 
    loop l4    
    
    ret
printbox endp


;Contiene el caracter a escribir

writecharat proc
    ;80x25
    push dx
    mov ax, dx
    and ax, 0FF00H
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    
    
    push bx
    mov bh, 160
    mul bh 
    pop bx
    and dx, 0FFH
    shl dx,1
    add ax, dx
    mov di, ax
    mov es:[di], bl
    pop dx
    ret    
writecharat endp
            
            
;dx contiene la fila y columna
;Devuelve el caracter en bl

readcharat proc
    push dx
    mov ax, dx
    and ax, 0FF00H
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1    
    push bx
    mov bh, 160
    mul bh 
    pop bx
    and dx, 0FFH
    shl dx,1
    add ax, dx
    mov di, ax
    mov bl,es:[di]
    pop dx
    ret
readcharat endp        

;dx contiene la fila y columna

;Escribe un elemento
escribirEn proc
    push dx
    mov ax, dx
    and ax, 0FF00H
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    shr ax,1
    
    push bx
    mov bh, 160
    mul bh
    
    pop bx
    and dx, 0FFH
    shl dx,1
    add ax, dx
    mov di, ax

loop_escribirEn:
    
    mov al, [bx]
    test al, al
    jz exit_escribirEn
    mov es:[di], al
    inc di
    inc di
    inc bx
    jmp loop_escribirEn
    
    
exit_escribirEn:

    pop dx
    ret
    
    
escribirEn endp
     
main endp
          
end main