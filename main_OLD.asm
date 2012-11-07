TITLE Towers of Hanoi						(main.asm)

; Description:
; 
; Revision date: 11/6/2012

INCLUDE Irvine32.inc
.data

;messages to print
	choiceMsg db "Which tower would you like to move to? Type 1, 2, or 3 and hit Enter:",0DH,0AH,0
	welcomeMsg db "Welcome to Tower of Hanoi. This is your starting tower:",0DH,0AH,0
	wrongInputMsg db "Your input is invalid and you do not deserve to play. Good Bye.",0DH,0AH,0
	AMsg db "This is tower A",0DH,0AH,0
	BMsg db "This is tower B",0DH,0AH,0
	CMsg db "This is tower C",0DH,0AH,0
	movedToA db "Moved disk to tower A",0DH,0AH,0
	movedToB db "Moved disk to tower B",0DH,0AH,0
	movedToC db "Moved disk to tower C",0DH,0AH,0

;these are the tower (column) arrays
	towerArrA db 1,2,3
	towerArrB db (0)
	towerArrC db (0)

;these are tower selectors (not in use yet)
	towerA db 1
	towerB db 2
	towerC db 3

;these aren't used yet
	myvar db ?
	diskA db ?
	diskB db ?
	diskC db ?

.code
main PROC
	mov edi,OFFSET towerArrA

;set counter
	mov ecx,3

;print welcome message	
	mov edx,OFFSET welcomeMsg
	call WriteString
	call Crlf
	
;print starting tower	
	printStart:
		mov al,[edi]
		movzx eax,al
		call WriteInt
		call CRLF
		inc edi
		loop printStart

;prompt user to select tower to move ring to
	call Crlf
	mov edx,OFFSET choiceMsg
	call WriteString
	call Crlf
	
;read user input
;determine if input is valid
	call ReadInt
	cmp towerC,al
	je MoveToTowerC

;if input is invalid print error message and end game
	wrongInput:
		cmp towerB,al
		je MoveToTowerB
		mov edx,OFFSET wrongInputMsg
		call WriteString
		jmp ThisIsTheEnd

;if input = 2 move to tower B
	MoveToTowerB:
		mov edi,OFFSET towerArrA
		mov esi,OFFSET towerArrB
		mov al,[edi]
		mov [esi],al
		inc edi
		mov edx,OFFSET movedToB
		call WriteString 
		jmp PrintArrays

;if input = 3 move to tower C
	MoveToTowerC:
		mov edi,OFFSET towerArrA
		mov esi,OFFSET towerArrC
		mov al,[edi]
		mov [esi],al
		inc edi
		mov edx,OFFSET movedToC
		call WriteString

	PrintArrays:
		mov ecx,2
		call Crlf
		call Crlf
		mov edx,OFFSET AMsg
		call WriteString

		mov edi,OFFSET towerArrA
		add edi,1
		printA:
			mov al,[edi]
			movzx eax,al
			call WriteInt
			call CRLF
			inc edi
			loop printA

		mov ecx,1
		sub esi,1
		call Crlf
		call Crlf
		mov edx,OFFSET BMsg
		call WriteString

		printB:
			mov esi,OFFSET towerArrB
			mov al,[esi]
			movzx eax,al
			call WriteInt
			call CRLF
			dec esi
			loop printB

		mov ecx,1
		sub esi,1
		call Crlf
		call Crlf
		mov edx,OFFSET CMsg
		call WriteString

		printC:
			mov esi,OFFSET towerArrC
			mov al,[esi]
			movzx eax,al
			call WriteInt
			call CRLF
			dec esi
			loop printC
	
	ThisIsTheEnd:	
	exit
main ENDP


	

END main