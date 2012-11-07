TITLE Towers of Hanoi						(main.asm)

; Description:
; 
; Revision date: 11/6/2012

INCLUDE Irvine32.inc
.data

;messages to print
	choiceMsg db "Chose the source tower and the destination towers separated by a coma.",0DH,0AH
	exampleMsg db "Example: 3,2 - Moves a disk from tower 3 to tower 2:",0DH,0AH,0
	welcomeMsg db "Welcome to Tower of Hanoi. This is your starting tower:",0DH,0AH,0
	wrongInputMsg db "Your input is invalid and you do not deserve to play. Good Bye.",0DH,0AH,0
	AMsg db "This is tower A",0DH,0AH,0
	BMsg db "This is tower B",0DH,0AH,0
	CMsg db "This is tower C",0DH,0AH,0
	movedToA db "Moved disk to tower A",0DH,0AH,0
	movedToB db "Moved disk to tower B",0DH,0AH,0
	movedToC db "Moved disk to tower C",0DH,0AH,0
	victoryMsg db "Congratulations! You won!",0DH,0AH,0
	hellod db "hey there D",0DH,0AH,0

;these are the tower (column) arrays
	towerArrA db 1,2,3
	towerArrB db 3 DUP (0)
	towerArrC db 3 DUP (0)

;these are tower selectors
	towerA db 1
	towerB db 2
	towerC db 3

;variables in use
	userMove db 4 DUP (0)
	srcTower db ?
	dstnTower db ?
	count db ?
	baseA dd ?
	baseB dd ?
	baseC dd ?
	towerPosA db 0
	towerPosB db 0
	towerPosC db 0
	srcPosA db 0
	srcPosB db 0
	srcPosC db 0
	emptyTowerCheck db 0

.code
main PROC

call Welcome
call saveTowerLocations
call printStartTower

Gameplay:
		
	call userInput

	call Crlf
	call Crlf
	call setSrcTower
	call moveToDstnTower
	call PrintArrays
	call VictoryCheck

	mov ecx,2
	mov al,[edi]
	call WriteInt
	loop Gameplay

	ThisIsTheEnd:	

	exit
main ENDP
;---------------------------------------------
;|				PROCEDURES					 |
;---------------------------------------------


;*************** WELCOME ********************
Welcome PROC
	;print welcome message	
		mov edx,OFFSET welcomeMsg
		call WriteString
		call Crlf
ret
Welcome ENDP

;********* TOWER BASE POSITIONS *************
saveTowerLocations PROC
	mov edi,OFFSET towerArrA
	mov baseA,edi
	mov edi,OFFSET towerArrB
	mov baseB,edi
	mov edi,OFFSET towerArrC
	mov baseC,edi
ret
saveTowerLocations ENDP

;********* PRINT INITIAL TOWER **************
printStartTower PROC
	;print starting tower
		mov ecx,3
		mov edi,OFFSET towerArrA			
		printStart:
			mov al,[edi]
			movzx eax,al
			call WriteInt
			call CRLF
			inc edi
			loop printStart
			call Crlf
ret
printStartTower ENDP

;************** USER INPUT ******************
userInput PROC
	mov edx,OFFSET choiceMsg
	call WriteString
	
	;read user input
		call Crlf
		mov al,9
		call WriteChar
		mov edx,OFFSET userMove
		mov ecx,SIZEOF userMove
		call ReadString

		mov esi,OFFSET userMove
		mov bl,[esi]
		sub bl,48
		mov srcTower,bl
		add esi,2
		mov bl,[esi]
		sub bl,48
		mov	dstnTower,bl
		call inputValidation
ret
userInput ENDP

;********** INPUT VALIDATION ******************
inputValidation PROC
	mov bl,dstnTower
	cmp srcTower,bl
	je inputInvalid
	ret
	inputInvalid:
		call wrongInput
	ret
inputValidation ENDP
;************* WRONG INPUT *******************
wrongInput Proc
	mov edx,OFFSET wrongInputMsg
	call WriteString
	exit
wrongInput ENDP

;*********** SET SOURCE TOWER ****************
setSrcTower PROC 
	cmp srcTower,1
	je startAtA
	cmp srcTower,2
	je startAtB
	cmp srcTower,3
	je startAtC

	call wrongInput
	ret

	startAtA:
		mov edi,OFFSET towerArrA
		mov bl,srcPosA
		movzx ebx,bl
		add edi,ebx
		ret
	startAtB:
		mov edi,OFFSET towerArrB
		mov bl,srcPosB
		movzx ebx,bl
		add edi,ebx
		ret
	startAtC:
		mov edi,OFFSET towerArrC
		mov bl,srcPosC
		movzx ebx,bl
		add edi,ebx
		ret
ret
setSrcTower ENDP

;***** MOVE TO DESTINATION TOWER ************
moveToDstnTower PROC uses edi
	mov al,[edi]
	call WriteInt
	mov bl,dstnTower
	cmp towerA,bl
	je moveToA
	cmp towerB,bl
	je moveToB
	cmp towerC,bl
	je moveToC

	call wrongInput
	ret


	;if dstnTower = 1 move to tower A
		moveToA:
			mov esi,OFFSET towerArrA
			mov bl,towerPosA
			movzx ebx,bl
			add esi,ebx
			mov bl,towerPosA
			mov emptyTowerCheck,bl
			call moveValidation
			inc towerPosA
			mov al,[edi]
			mov [esi],al
			mov al,0
			mov [edi],al
			inc srcPosA
			mov edx,OFFSET movedToA
			call WriteString 
			ret


	;if dstnTower = 2 move to tower B
		moveToB:
			mov esi,OFFSET towerArrB
			mov bl,towerPosB
			movzx ebx,bl
			add esi,ebx
			mov bl,towerPosB
			mov emptyTowerCheck,bl
			call moveValidation
			inc towerPosB
			mov al,[edi]
			mov [esi],al
			mov al,0
			mov [edi],al
			inc srcPosB
			mov edx,OFFSET movedToB
			call WriteString 
			ret

	;if dstnTow = 3 move to tower C
		moveToC:
			mov esi,OFFSET towerArrC
			mov bl,towerPosC
			movzx ebx,bl
			add esi,ebx
			mov bl,towerPosC
			mov emptyTowerCheck,bl
			call moveValidation
			inc towerPosC
			mov al,[edi]
			mov [esi],al
			mov al,0
			mov [edi],al
			inc srcPosC
			mov edx,OFFSET movedToC
			call WriteString 
			ret

	EndOfProc:
ret
moveToDstnTower ENDP

;*********** MOVE VALIDATION ****************
moveValidation PROC uses esi edi
	mov bl,[esi]
	mov dl,emptyTowerCheck
	cmp dl,0
	je validMove
	cmp al,bl
	jnl invalidMove

	validMove:
		ret
	invalidMove:
		call WrongInput
moveValidation ENDP

;********** DISPLAY TOWERS ******************
PrintArrays PROC
	call Crlf
	call Crlf
	
	mov edx,OFFSET AMsg
	call WriteString
	mov ecx,3
	mov edi,OFFSET towerArrA
	printA:
		mov al,[edi]
		movzx eax,al
		call WriteInt
		call CRLF
		inc edi
		loop printA

	call Crlf
	call Crlf

	mov edx,OFFSET BMsg
	call WriteString
	mov ecx,3
	mov edi,OFFSET towerArrB
	printB:
		mov al,[edi]
		movzx eax,al
		call WriteInt
		call CRLF
		inc edi
		loop printB
		
	call Crlf
	call Crlf

	mov edx,OFFSET CMsg
	call WriteString
	mov ecx,3
	mov edi,OFFSET towerArrC
	printC:
		mov al,[edi]
		movzx eax,al
		call WriteInt
		call CRLF
		inc edi
		loop printC

ret
PrintArrays ENDP

;************ VICTORY CHECK *****************
VictoryCheck PROC
	mov esi,OFFSET towerArrC
	mov bl,[esi]
	cmp bl,1
	jne keepPlaying
	inc esi
	mov bl,[esi]
	cmp bl,2
	jne keepPlaying
	inc esi
	mov bl,[esi]
	cmp bl,3
	jne keepPlaying
	call Victory

	keepPlaying:
ret
VictoryCheck ENDP

;*************** VICTORY *******************
Victory PROC
	call Crlf
	call Crlf
	mov edx,OFFSET victoryMSG
	call WriteString
exit
Victory ENDP

END main




comment !
	mov count,3
	mov cl,count
	Loop1:
		mov count,cl
		mov edx,OFFSET ohno
		call WriteString
		mov cl,2
		Loop2:
			mov edx,OFFSET hellod
			call WriteString
			loop Loop2
		mov cl,count
		loop Loop1
!