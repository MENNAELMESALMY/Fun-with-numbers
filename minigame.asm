	extrn player:far
	extrn no0:far
	extrn no1:far
	extrn no2:far
	extrn no3:far
	extrn no4:far
	extrn no5:far
	extrn no6:far
	extrn no7:far
	extrn no8:far
	extrn no9:far
.model large
.stack 64
.data
numarr dw 5,6,7,8,9,3           ;;array for the numbers that fall from top to bottom(will be randomally generated afterwards)
numatx dw 70,170,270,370,470,570;;number position in x
numaty dw 75			;;number position in y
counter db 0			;;counter of steps the number array moved to know when to restart
rand  dw ?			;;save the random number
right db 0			;;to know if the player pressed the right arrow to clear
correct db 'Right answer : $'
notcorrect db 'Wrong answers : $'
lost db 'HardLuck:( Try Again $'
won db 'Congrats!!Getting Better$'
toplay db 'To Play Press Enter$'
toexit db 'To Exit Press Esc$'
rightans db 0                   ;;counter of right answers
wrongans db 0 			;;counter of wrong answers
;;;
endflag db 0			;;turn to one if Esc key is pressed of if the player won/lost to return to menu and restart
playerx dw 300			;;pikacho position in x
playery dw 450			;;pikacho position in y
;;
op1 dw ?			;;first operand displayed
op2 dw ?			;;second operand displayed
op db ?				;;operation to print '+'||'*'||'-'
operation db 0			;;operation 0=>add 1=>sub 2=>mul
res dw ?			;;expected result
numtaken dw 4 dup('$')		;;collected numbers
numchk dw ?			;;the collected number to compare with expected
numpointer dw 0			;;to know how many digits are collected
qflag db 0                      ;;flag to check if there is already a question in 
                                ;;display or not 0=>no question 1=>question
printx db ?			;;question expexted pos. to print
printy db 0
;;
xmin dw ?
xmax dw ?                       ;;to test the upper limit and the lower limit 
                                ;;of each number
.code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;sound functions;;;dina alaa wrote it during our team project from which i took them;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rightsound proc far
push ax
push bx
push cx
push dx
sound :     

MOV     DX,2000          ; Number of times to repeat whole routine.

MOV     BX,1             ; Frequency value.

MOV     AL, 10110110B    ; The Magic Number (use this binary number only)
OUT     43H, AL          ; Send it to the initializing port 43H Timer 2.

NEXT_FREQUENCY:          ; This is were we will jump back to 2000 times.

MOV     AX, BX           ; Move our Frequency value into AX.

OUT     42H, AL          ; Send LSB to port 42H.
MOV     AL, AH           ; Move MSB into AL  
OUT     42H, AL          ; Send MSB to port 42H.

IN      AL, 61H          ; Get current value of port 61H.
OR      AL, 00000011B    ; OR AL to this value, forcing first two bits high.
OUT     61H, AL          ; Copy it to port 61H of the PPI Chip
                         ; to turn ON the speaker.

MOV     CX, 100          ; Repeat loop 100 times
DELAY_LOOP:              ; Here is where we loop back too.
LOOP    DELAY_LOOP       ; Jump repeatedly to DELAY_LOOP until CX = 0


INC     BX               ; Incrementing the value of BX lowers 
                         ; the frequency each time we repeat the
                         ; whole routine

DEC     DX               ; Decrement repeat routine count

CMP     DX, 0            ; Is DX (repeat count) = to 0
JNZ     NEXT_FREQUENCY   ; If not jump to NEXT_FREQUENCY
                         ; and do whole routine again.

                         ; Else DX = 0 time to turn speaker OFF

IN      AL,61H           ; Get current value of port 61H.
AND     AL,11111100B     ; AND AL to this value, forcing first two bits low.
OUT     61H,AL           ; Copy it to port 61H of the PPI Chip
                         ; to
pop dx
pop cx
pop bx
pop ax
ret
rightsound endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;credited to:dina alaa;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wrongsound proc far 
mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 4560        ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 25          ; Pause for duration of note.
.pause1:
        mov     cx, 65535
.pause2:
        dec     cx
        jne     .pause2
        dec     bx
        jne     .pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al
ret
wrongsound endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAYSTRING MACRO OUTMSG
		push ax
		push dx
                MOV AH,09H
                MOV DX,OFFSET OUTMSG
                INT 21H
		pop dx 
		pop ax
ENDM DISPLAYSTRING 
;;;;;;;randomize the first number in array then get the other elements from it;;;;;;;;;;;;;;;;;
randomize proc
   push ax
   push bx
   push cx
   push dx
   jmp beg
adjust:
   mov ax,5
   cmp rand,ax
   jz minus
   inc rand
   mov dx,rand
   jmp complete
 minus:
   dec rand
   mov dx,rand
   jmp complete
   beg:
   mov bx,0
   
   MOV AH, 2ch  ; interrupts to get system time        
   INT 21H         
  
   mov  ax, dx
   xor dx,dx
   mov  cx,4 
   div  cx       ; here dx contains the remainder of the division - from 0 to 3
   add dx,2      ;get it in range[2..5]
   cmp rand,dx   ;;make sure no two consecutive randoms are equal
   jz adjust
   mov rand,dx
complete:
   mov numarr[bx],dx  ;0 pos in array
   
   add bx,2           ;1 pos in array
   sub dx,2
   mov numarr[bx],dx  
   add bx,2           ;2
   mov dx,rand  
   sub dx,1
   mov numarr[bx],dx
   add bx,2           ;3
   mov dx,rand  
   add dx,1
   mov numarr[bx],dx
   add bx,2           ;4
   mov dx,rand  
   add dx,3
   mov numarr[bx],dx
   add bx,2           ;5
   mov dx,rand  
   add dx,4
   mov numarr[bx],dx
 
   pop dx
   pop cx
   pop bx
   pop ax
ret
randomize endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;check the number accumulated from user in numtaken var;;;;;;;
checkres proc
   push ax
   push bx
   push cx
   push dx
	mov ax,0
	mov numchk,ax                  ;;intialise numchk
	mov bx,numpointer
	cmp bx,0
	jz wrong	               ;;if no number was taken then we have no answer(wrong point)
	mov cx,1                       ;;multiplied by least significant number
	readtochk:
		sub bx,2
		mov ax,numtaken[bx]    ;;get digit
		mul cx		       ;;mul by(1=>unit 10=>tens..)
		add numchk,ax
		mov ax,cx
		mov cx,10
		mul cx		       ;;cx=cx*10
		mov cx,ax
		cmp bx,0
		jnz readtochk
chkres:
	mov ax,res			;;compare with expected result
	cmp ax,numchk
	jnz wrong

	inc rightans
	call rightsound
	jmp exitcheck
wrong:
	inc wrongans
	call wrongsound
	jmp exitcheck
exitcheck:	
   pop dx
   pop cx
   pop bx
   pop ax
ret
checkres endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;update score and enable adding new question;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updatebar proc
      push ax
      push bx
      push cx
      push dx
;;;;;clear bar;;;;;;;;;;;;;;;
        mov cx,0
	mov dx,0
	mov al,00h
	mov ah,0ch
	bary:
	      barx: 
	      int 10h
   	      inc cx
	      cmp cx,640
	      jnz barx
	mov cx,0
	inc dx
	cmp dx,25
	jnz bary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;string of right
	mov ah,2
	MOV Bx,0
        MOV DL,0
	MOV DH,0
        INT 10H
	displaystring correct
;;;;;;;;;;;;;;;;;;;;;;;;;updated score
	MOV AH,9
	MOV BH,00H
	MOV BL,0fH
	mov al,rightans
	add al,'0'
	MOV CX,1
	INT 10H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;string of wrong
	mov ah,2
	MOV Bx,0
        MOV DL,60
	MOV DH,0
	INT 10H
	displaystring notcorrect
;;;;;;;;;;;;;;;;;;;;;;;;;updated score
	MOV AH,9
	mov al,wrongans
	add al,'0'
	MOV BH,00H
	MOV BL,0fH
	MOV CX,1
	INT 10H
	mov numpointer,0
	mov al,qflag
	cmp al,0
	jz endbar
	dec qflag
endbar:
	
   pop dx
   pop cx
   pop bx
   pop ax
ret
updatebar endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;check pressed key enter/right or left arrow escape;;;;;;;;;;;;;
checkpress proc
	cmp al,1bh
	jz endg
	cmp al,13
	jz checkanswer
	cmp ah,75
	jz toleft
	cmp ah,77
	jz toright
	jmp endcheck
checkanswer:            ;;enter is pressed or more than four digits 
	;;reset
	call checkres
	call updatebar  ;;to update score
	jmp endcheck
toleft:	
	cmp playerx,25 ;;not out of screen
	jle endcheck
	sub playerx,15  ;;move player
	jmp endcheck
toright:
	cmp playerx,615  ;;not out of screen
	jz endcheck
	inc right
	add playerx,15  ;;move player 
	jmp endcheck
endg:
	mov ah,1       ;;Esc 
	mov endflag,ah ;;set end flag
endcheck:
	mov ah,0
	int 16h
ret
checkpress endp  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;inc number step and redraw scene;;;;;;;;;;;;;;;;;
numbers proc
	push dx
	push cx
	push bx
	push ax
        add numaty,10
	mov bx,0
	inc counter 
	jmp rain
zero:
	call no0
	jmp rain
one:
	call no1
	jmp rain
two:
	call no2
	jmp rain
three:
	call no3
	jmp rain
four:
	call no4
	jmp rain
five:
	call no5
	jmp rain
six:
	call no6
	jmp rain
seven:
	call no7
	jmp rain
eight:
	call no8
	jmp rain
nine:
	call no9
	rain:
	     cmp bx,12
	     JZ endrain
	     mov cx,numatx[bx]	     
	     mov dx,numaty
	   
	     mov ax ,numarr[bx]
	     add bx,2
	     cmp ax,0
	     jz zero
	     cmp ax,1
	     jz ONE
	     cmp ax,2
	     jz two
	     cmp ax,3
	     jz three
	     cmp ax,4
	     jz four
	     cmp ax,5
	     jz five
	     cmp ax,6
	     jz six
	     cmp ax,7
	     jz seven
	     cmp ax,8
	     jz eight
	     cmp ax,9
	     jz nine
	     jmp rain
        endrain:
	pop ax
	pop bx	
	pop cx
	pop dx
ret
numbers endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; clearing the step of the number array;;;;;;;;;;;;;;;;;;;;;;
clearnumbers proc
	push dx
	push cx
	push bx
	push ax
;;;;;;;;;;;;;;;numbers clear;;;;;;;;;;;;;;;;;;;;;
	mov bx,numaty
	sub bx,53
	mov cx,0
	mov dx,bx
	add bx,10
	mov al,0fh
	mov ah,0ch
	clry:
	      clrx: 
	      int 10h
   	      inc cx
	      cmp cx,640
	      jnz clrx
	mov cx,0
	inc dx
	cmp dx,bx
	jnz clry
;;;;;;;;;;;;;;;;player moved to right then clear;;;;;;;;;;;;;;;;;;;
	cmp right,0
	jz endclr
	dec right
	mov bx,playerx
	sub bx,35
	mov cx,bx
	mov dx,433
	mov al,0fh
	mov ah,0ch
	pekay:
	      add bx,10
	      pekax: 
	      int 10h
   	      inc cx
	      cmp cx,bx
	      jnz pekax
	sub bx,10
	mov cx,bx
	inc dx
	cmp dx,466
	jnz pekay
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
endclr:	
	pop ax
	pop bx	
	pop cx
	pop dx
	
ret 
clearnumbers endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updatescreen proc
	push ax
	push bx
	push cx
	push dx
	
	mov ch,counter
	cmp ch,50
	jz reset
strtupdate:
	call clearnumbers
	call numbers	
	mov cx,playerx
	mov dx,playery
	call player  ;;redraw player in new position
	
	jmp endupdate
reset:
	mov counter,0   ;;get numbers to begining
	mov numaty,75	   
	call randomize  ;;regenerate number array
	jmp strtupdate
endupdate:

	pop dx
	pop cx
	pop bx
	pop ax
ret
updatescreen endp
;;;;;;;;;;;;;;;;;given a position print digit;;;;;;;;;;;;;;;;;;;;;;;;
printatpos Macro x1,y1
        PUSH AX 
        PUSH BX
        PUSH CX
        PUSH DX 

	mov ah,2
	MOV Bx,0
        MOV DL,x1
	MOV DH,y1
        INT 10H
	MOV AH,9
	MOV BH,00H
	MOV BL,0fH
	MOV CX,1
	INT 10H

	POP DX
        POP CX
        POP BX
        POP AX
 
endm printatpos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;taken from geeks for geeks page and updated for the game use;;;;;
PRINT PROC 
    PUSH AX 
    PUSH BX
    PUSH CX
    PUSH DX          
 
    mov cx,0                       ;INITIALISE COUNT
    mov dx,0 
	cmp ax,0
	jnz label1
	inc cx 
	push ax
    label1:  
        cmp ax,0                   ;MEANS THAT NO VALUE IS REMAINING TO PRINT 
        je print1       
         
        mov bx,10         
        div bx                    ;DIVIDE BY 10 TO GET THE LEAST SIGNIFICANT DIGIT              
          
        push dx                   ;push it in the stack           
        inc cx                    ;INC TO KNOW HOW MANY TIMES TO POP THE STACK         
          
        xor dx,dx                 ;set dx to 0 
        jmp label1 
    print1: 
        cmp cx,0                  ;CHECK COUNT
        je exit
          
        pop dx       

        add dx,'0'                ;CONVERT TO ASCII REPRESENTING THE DIGIT
	mov al,dl
	printatpos printx,printy
        inc printx      
        dec cx     ;DEC COUNT
        jmp print1 
exit: 
  POP DX
  POP CX
  POP BX
  POP AX
  RET 
print endP
;;;;;;;;;;;;;;;;;;;;;;;;print the question after we form it;;;;;;;;;;;;;;;;;    
printques proc
    PUSH AX 
    PUSH BX
    PUSH CX
    PUSH DX  
	mov al,35
	mov printx,al
	mov ax,0
	mov ax,op1
	call print 
	mov al,op
	printatpos printx,printy
	inc printx
	mov ax,op2
	call print 
	mov al,'='
	printatpos printx,printy
	inc printx
	
    POP DX
    POP CX
    POP BX
    POP AX
ret
printques endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
question proc
    PUSH AX 
    PUSH BX
    PUSH CX
    PUSH DX 
	mov bx,100
	mov al,qflag
	cmp al,0
	jnz temp ;;temporary jump
   
        MOV AH, 2ch  ; interrupt to get system time        
        INT 21H  
  
        mov  ax, dx
        xor dx,dx

        div  bx   
	mov op1,dx   ;randomize first operand
	
	MOV AH, 2ch  ; interrupt to get system time        
        INT 21H     
  
        mov  ax, dx
        xor dx,dx

	sub bx,49    ;randomize but in smaller range
        div  bx   
	mov op2,dx
	
	MOV AH, 2ch  ; interrupt to get system time        
        INT 21H     
        mov  ax, dx
        xor dx,dx
        sub  bx,39   ;randomize a factor to add to second operand
        div  bx   
	add op2,dx
	mov ax,op1
	mov bx,op2
	cmp ax,bx
	jg positiveans
	mov bx,op1   ;;swapped so we have no negative answer
	mov ax,op2
	mov op1,ax
	mov op2,bx
positiveans:
	mov ch,operation
	cmp ch,0
	jz addition
	cmp ch,1
	jz subtraction
	jmp multiply
temp:
    jmp haveone
addition:
        mov op,'+'
	inc operation
	add ax,bx
	mov res,ax
	jmp goprint
subtraction:
        mov op,'-'
	inc operation
	sub ax,bx
	mov res,ax
	jmp goprint
multiply:
        mov op,'*'
	mul bx
	mov res,ax
	sub operation,2
	jmp goprint

goprint:
	inc qflag        ;;set i have a question flag
	call printques     
haveone:
   POP DX
   POP CX
   POP BX
   POP AX
ret
question endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
detectcollide proc
	 PUSH AX 
         PUSH BX
         PUSH CX
         PUSH DX 
	mov ax,numaty   
	cmp ax,374      ;;check y range =>above
	jl endcollision
	cmp ax,493      ;;check y range =>under
	jg endcollision

	mov ax,playerx
	mov bx,0
	checkcollide:   ;;check if in range of any of the six numbers
	     mov cx,numatx[bx]
	     mov xmin,cx
	     sub xmin,25
	     mov xmax,cx
	     add xmax,25
	     cmp ax,xmin
	     jl notin
	     cmp xmax,ax
	     jl notin
	     mov ax,numarr[bx]
	     cmp ax,10
	     jz endcollision
	     call print
	     mov numarr[bx],10	
	     mov bx,numpointer
	     add numpointer,2
	     mov numtaken[bx],ax
	     mov bx,numpointer
	     cmp bx,8         ;;the user took four digits
	     jz maxno
	     jmp endcollision     
notin:
	     add bx,2
	     cmp bx,12
	    jnz checkcollide
	    jmp endcollision
maxno:	
	call checkres
	call updatebar 
endcollision:	
	 POP DX
         POP CX
         POP BX
         POP AX
ret 
detectcollide endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;delay sec;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SLEEPSEC PROC
    push cx
    MOV AH,2CH
    INT 21H
    MOV AL,DH ;;;;;TAKE THE SECOND IN WHICH I ENTER THE PROC
    WAITSEC:
	INT 21H
	CMP DH,AL
   JZ WAITSEC ;;;;;WAIT TILL SECOND IS INCREMENTED THEN RETURN
   POP CX
   RET
SLEEPSEC ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;the player won/lost;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lastscreen proc
	 PUSH AX 
         PUSH BX
         PUSH CX
         PUSH DX 
	mov ah,rightans
	mov al,wrongans
        cmp ah,9
	jz endgame
        cmp al,3
	jnz notend
endgame:
	mov endflag,1
	;;;;;change the video mode to lower resolution
	mov ah,0
	mov al,13h
	int 10h
	;;;;;clear the screen with black
	mov ax,0600h
	mov bh,0fh
	mov cx,0
	mov dx,184fh
	int 10h
	;;;;;draw a logo
	mov cx,120
	mov dx,50
	call no1
	mov cx,180
	mov dx,60
	call no2
	mov cx,240
	mov dx,60
	call no3
	;;;;;write you win or you lose
	mov ah,2
	MOV Bx,0
        MOV DL,10
	MOV DH,16
        INT 10H
	mov ah,rightans
	cmp ah,9
	jz str1
	displaystring lost
	jmp thepause
str1:
	displaystring won
	;;;;;wait for five seconds
thepause:
	mov cx,5
	hold:
	    call sleepsec
	loop hold
notend:
	 POP DX
         POP CX
         POP BX
         POP AX
ret
lastscreen endp
;;;;;;;;;;;;;;;;;;;when entering the game reset variables;;;;;;;;;;;;;;
resetvar Macro
	
        mov numarr[0],9
	mov numarr[2],5
	mov numarr[4],7
	mov numarr[6],1
	mov numarr[8],0
	mov numarr[10],4
	mov numaty,75
	MOV counter,0
      
	MOV rightans,0
	MOV wrongans,0
	MOV endflag,0
	mov playerx,300
	mov playery,450
	
	MOV numpointer,0
	MOV operation,0

	MOV qflag,0
	MOV printy,0

endm resetvar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mainmenu proc
	resetvar
begmenu:	
	mov ah,0
	mov al,13h
	int 10h
	;;;;;clear the screen with black
	mov ax,0600h
	mov bh,0fh
	mov cx,0
	mov dx,184fh
	int 10h
	;;;;;draw logo
	mov cx,120
	mov dx,50
	call no1
	mov cx,180
	mov dx,60
	call no2
	mov cx,240
	mov dx,60
	call no3
	;;;;;write option1 ;;set cursor then display string
	mov ah,2
	MOV Bx,0
        MOV DL,11
	MOV DH,15
        INT 10H
	displaystring toplay
	;;;;;write option1 ;;set cursor then display string
	mov ah,2
	MOV Bx,0
        MOV DL,12
	MOV DH,18
        INT 10H
	displaystring toexit
	;;;;;;
waitmore:   ;;wait here till a valid key if pressed
	mov ah,0
	int 16h
	cmp al,1bh
	jz endmenu
	cmp al,13
	jnz waitmore
	jmp exitmenu
endmenu:   ;;;if he/she pressed exit alert flag
 	mov endflag,1
exitmenu:

ret
mainmenu endp
;;;;;;;;;;;;;;;;;;;
main proc far             
	mov ax,@data
	mov ds,ax  
begingame:             
	call mainmenu
	mov ch,endflag
	cmp ch,1
        jz theend
	mov ax,4f02h ;change to video mode 640*480
	mov bx,101h
	int 10h
;;;;clear screen with white color;;;;;;;;;;;;;;
	mov cx,0
	mov dx,0
	mov al,0fh
	mov ah,0ch
	whitey:
	      whitex: 
	      int 10h
   	      inc cx
	      cmp cx,640
	      jnz whitex
	mov cx,0
	inc dx
	cmp dx,480
	jnz whitey
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;draw status bar;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call updatebar
;;main game loop
	play:     
	    call updatescreen
	    call question
	    call detectcollide  
	    call lastscreen ;;check if the game is won/lost
	    mov ch,endflag
	    cmp ch,1
	    jz begingame
	    mov ah,1
	    int 16h
	jz play	

	call checkpress
	mov ch,endflag
	cmp ch,1
	jz begingame
	jmp play
;;;;;;;;;;;;;;;;;;;return control ;;;;;;;;;;;;;;;;
theend:	

	MOV AH,4CH
	INT 21H
main endp 

end main 