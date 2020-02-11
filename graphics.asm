        public player
	public no0
	public no1
	public no2
	public no3
	public no4
	public no5
	public no6
	public no7
	public no8
	public no9
.model large
.stack 64
.data
;;;
pecaWidth equ 50
pecaHeight equ 33
wi dw 0
he dw 0
BEGX DW ?
pecaFilename DB 'peca.bin', 0
pecaFilehandle DW ?
pecaData DB pecaWidth*pecaHeight dup(0)
;;;
Width0 equ 50
Height0 equ 74
Filename0 DB 'no0.bin', 0
Filehandle0 DW ?
Data0 DB Width0*Height0 dup(0)
;;;
;;;
Width1 equ 50
Height1 equ 78
Filename1 DB 'no1.bin', 0
Filehandle1 DW ?
Data1 DB Width1*Height1 dup(0)
;;;
;;;
Width2 equ 50
Height2 equ 53
Filename2 DB 'no2.bin', 0
Filehandle2 DW ?
Data2 DB Width2*Height2 dup(0)
;;;
;;;
Width3 equ 50
Height3 equ 50
Filename3 DB 'no3.bin', 0
Filehandle3 DW ?
Data3 DB Width3*Height3 dup(0)
;;;
;;;
Width4 equ 50
Height4 equ 74
Filename4 DB 'no4.bin', 0
Filehandle4 DW ?
Data4 DB Width4*Height4 dup(0)
;;;
;;;
Width5 equ 50
Height5 equ 50
Filename5 DB 'no5.bin', 0
Filehandle5 DW ?
Data5 DB Width5*Height5 dup(0)
;;;
;;;
Width6 equ 50
Height6 equ 58
Filename6 DB 'no6.bin', 0
Filehandle6 DW ?
Data6 DB Width6*Height6 dup(0)
;;;
;;;
Width7 equ 50
Height7 equ 65
Filename7 DB 'no7.bin', 0
Filehandle7 DW ?
Data7 DB Width7*Height7 dup(0)
;;;
;;;
Width8 equ 50
Height8 equ 78
Filename8 DB 'no8.bin', 0
Filehandle8 DW ?
Data8 DB Width8*Height8 dup(0)
;;;
;;;
Width9 equ 50
Height9 equ 86
Filename9 DB 'no9.bin', 0
Filehandle9 DW ?
Data9 DB Width9*Height9 dup(0)
;;;
.code 
player proc far
PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, pecaFilename
    INT 21h
    MOV [pecaFilehandle], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [pecaFilehandle]
    MOV CX,pecaWidth*pecaHeight ; number of bytes to read
    LEA DX, pecaData
    INT 21h
    ;;;;;;;;;;;;;;;;;;
	
    LEA BX , pecaData ; BL contains index at the current drawn pixel
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,17
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,16
    MOV BEGX,CX
    MOV AH,0ch
  
; Drawing loop
drawLoopL:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL 	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [pecaFilehandle]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
player endp   

;;;;
no0 proc far
PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename0
    INT 21h
    MOV [Filehandle0], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [Filehandle0]
    MOV CX,Width0*Height0 ; number of bytes to read
    LEA DX, Data0
    INT 21h
    ;;;;;;;;;;;;;;;;;;

    LEA BX , Data0 ; BL contains index at the current drawn pixel
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,37
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,49
    MOV BEGX,CX
    MOV AH,0ch
 
	mov bx,dx
	add bx,12
	mov al,0fh
	mov ah,0ch
	clry0:
	      clrx0: 
	      int 10h
   	      inc cx
	      cmp cx,wi
	      jnz clrx0
	mov cx,begx
	inc dx
	cmp dx,bx
	jnz clry0
  LEA BX , Data0 ; BL contains index at the current drawn pixel
; Drawing loop
drawLoopL0:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL0 	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL0

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [Filehandle0]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
no0 endp  
;;;;
no1 proc far
PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename1
    INT 21h
    MOV [Filehandle1], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [Filehandle1]
    MOV CX,Width1*Height1 ; number of bytes to read
    LEA DX, Data1
    INT 21h
    ;;;;;;;;;;;;;;;;;;  
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,39
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,47
    MOV BEGX,CX
    MOV AH,0ch
    mov bx,dx
	add bx,8
	mov al,0fh
	mov ah,0ch
	clry1:
	      clrx1: 
	      int 10h
   	      inc cx
	      cmp cx,wi
	      jnz clrx1
	mov cx,begx
	inc dx
	cmp dx,bx
	jnz clry1
  LEA BX , Data1 ; BL contains index at the current drawn pixel

; Drawing loop
drawLoopL1:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL1 	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL1

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [Filehandle1]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
no1 endp   

;;;;
no2 proc far
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename2
    INT 21h
    MOV [Filehandle2], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [Filehandle2]
    MOV CX,Width2*Height2 ; number of bytes to read
    LEA DX, Data2
    INT 21h
    ;;;;;;;;;;;;;;;;;;
	
    LEA BX , Data2 ; BL contains index at the current drawn pixel
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,27
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,59
    MOV BEGX,CX
    MOV AH,0ch
     mov bx,dx
	add bx,33
	mov al,0fh
	mov ah,0ch
	clry2:
	      clrx2: 
	      int 10h
   	      inc cx
	      cmp cx,wi
	      jnz clrx2
	mov cx,begx
	inc dx
	cmp dx,bx
	jnz clry2
  LEA BX , Data2 ; BL contains index at the current drawn pixel

  
; Drawing loop
drawLoopL2:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL2 	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL2

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [Filehandle2]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
no2 endp   

;;;;
no3 proc far
PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename3
    INT 21h
    MOV [Filehandle3], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [Filehandle3]
    MOV CX,Width3*Height3 ; number of bytes to read
    LEA DX, Data3
    INT 21h
    ;;;;;;;;;;;;;;;;;;
	
    LEA BX , Data3 ; BL contains index at the current drawn pixel
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,25
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,61
    MOV BEGX,CX
    MOV AH,0ch
    mov bx,dx
	add bx,36
	mov al,0fh
	mov ah,0ch
	clry3:
	      clrx3: 
	      int 10h
   	      inc cx
	      cmp cx,wi
	      jnz clrx3
	mov cx,begx
	inc dx
	cmp dx,bx
	jnz clry3
  LEA BX , Data3 ; BL contains index at the current drawn pixel

  
; Drawing loop
drawLoopL3:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL3	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL3

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [Filehandle3]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
no3 endp   

;;;;
no4 proc far
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename4
    INT 21h
    MOV [Filehandle4], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [Filehandle4]
    MOV CX,Width4*Height4 ; number of bytes to read
    LEA DX, Data4
    INT 21h
    ;;;;;;;;;;;;;;;;;;
	
    LEA BX , Data4 ; BL contains index at the current drawn pixel
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,37
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,49
    MOV BEGX,CX
    MOV AH,0ch
    mov bx,dx
	add bx,12
	mov al,0fh
	mov ah,0ch
	clry4:
	      clrx4: 
	      int 10h
   	      inc cx
	      cmp cx,wi
	      jnz clrx4
	mov cx,begx
	inc dx
	cmp dx,bx
	jnz clry4
  LEA BX , Data4 ; BL contains index at the current drawn pixel

  
; Drawing loop
drawLoopL4:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL4 	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL4

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [Filehandle4]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
no4 endp   

;;;;
no5 proc far
PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename5
    INT 21h
    MOV [Filehandle5], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [Filehandle5]
    MOV CX,Width5*Height5 ; number of bytes to read
    LEA DX,Data5
    INT 21h
    ;;;;;;;;;;;;;;;;;;
	
    LEA BX , Data5 ; BL contains index at the current drawn pixel
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,25
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,61
    MOV BEGX,CX
    MOV AH,0ch
    mov bx,dx
	add bx,36
	mov al,0fh
	mov ah,0ch
	clry5:
	      clrx5: 
	      int 10h
   	      inc cx
	      cmp cx,wi
	      jnz clrx5
	mov cx,begx
	inc dx
	cmp dx,bx
	jnz clry5
  LEA BX , Data5 ; BL contains index at the current drawn pixel

  
; Drawing loop
drawLoopL5:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL5	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL5

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [Filehandle5]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
no5 endp   
;;;;
no6 proc far
PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename6
    INT 21h
    MOV [Filehandle6], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [Filehandle6]
    MOV CX,Width6*Height6 ; number of bytes to read
    LEA DX, Data6
    INT 21h
    ;;;;;;;;;;;;;;;;;;
	
    LEA BX , Data6 ; BL contains index at the current drawn pixel
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,29
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,57
    MOV BEGX,CX
    MOV AH,0ch
    mov bx,dx
	add bx,28
	mov al,0fh
	mov ah,0ch
	clry6:
	      clrx6: 
	      int 10h
   	      inc cx
	      cmp cx,wi
	      jnz clrx6
	mov cx,begx
	inc dx
	cmp dx,bx
	jnz clry6
  LEA BX , Data6 ; BL contains index at the current drawn pixel

  
; Drawing loop
drawLoopL6:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL6 	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL6

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [Filehandle6]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
no6 endp   
;;;;
no7 proc far
PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename7
    INT 21h
    MOV [Filehandle7], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [Filehandle7]
    MOV CX,Width7*Height7 ; number of bytes to read
    LEA DX, Data7
    INT 21h
    ;;;;;;;;;;;;;;;;;;
	
    LEA BX ,Data7 ; BL contains index at the current drawn pixel
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,33
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,51
    MOV BEGX,CX
    MOV AH,0ch
    mov bx,dx
	add bx,21
	mov al,0fh
	mov ah,0ch
	clry7:
	      clrx7: 
	      int 10h
   	      inc cx
	      cmp cx,wi
	      jnz clrx7
	mov cx,begx
	inc dx
	cmp dx,bx
	jnz clry7
  LEA BX , Data7 ; BL contains index at the current drawn pixel

  
; Drawing loop
drawLoopL7:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL7 	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL7

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [Filehandle7]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
no7 endp 
;;;;
no8 proc far
PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename8
    INT 21h
    MOV [Filehandle8], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [Filehandle8]
    MOV CX,Width8*Height8 ; number of bytes to read
    LEA DX,Data8
    INT 21h
    ;;;;;;;;;;;;;;;;;;
	
    LEA BX , Data8 ; BL contains index at the current drawn pixel
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,39
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,47
    MOV BEGX,CX
    MOV AH,0ch
    mov bx,dx
	add bx,8
	mov al,0fh
	mov ah,0ch
	clry8:
	      clrx8: 
	      int 10h
   	      inc cx
	      cmp cx,wi
	      jnz clrx8
	mov cx,begx
	inc dx
	cmp dx,bx
	jnz clry8
  LEA BX , Data8 ; BL contains index at the current drawn pixel
  
; Drawing loop
drawLoopL8:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL8 	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL8

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [Filehandle8]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
no8 endp 
;;;;
no9 proc far
PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH CX
    PUSH DX
    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, Filename9
    INT 21h
    MOV [Filehandle9], AX
    ;;;;;;;;;;;read data
    MOV AH,3Fh
    MOV BX, [Filehandle9]
    MOV CX,Width9*Height9 ; number of bytes to read
    LEA DX, Data9
    INT 21h
    ;;;;;;;;;;;;;;;;;;
	
    LEA BX , Data9 ; BL contains index at the current drawn pixel
    POP DX
    POP CX
    MOV he,dx
    MOV wi,cx
    add he,43
    add wi,25
    SUB CX,25       ;;;;;;ADJUST TO TOP LEFT
    SUB DX,43
    MOV BEGX,CX
    MOV AH,0ch
  
; Drawing loop
drawLoopL9:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,wi
JNE drawLoopL9	
    MOV CX ,BEGX	
    INC DX
    CMP DX , he
JNE drawLoopL9

    ;;;;;;;;;;;;;;;;close file
    MOV AH, 3Eh
    MOV BX, [Filehandle9]
    INT 21h

    POP DX
    POP CX
    POP BX
    POP AX
ret 
no9 endp   
;;;;
END