TITLE Towers of Hanoi - Final Version						(main.asm)


INCLUDE Irvine32.inc
.data

	towerA BYTE 7 DUP(0)
	padding1 BYTE 0
	towerB BYTE 7 DUP(0)
	padding2 BYTE 0
	towerC BYTE 7 DUP(0)
	padding3 BYTE 0
	sourceList1 BYTE 1,1,3,1,2,2,1,1,3,3,2,3,1,1,3,1,2,2,1,2,3,3,2,2,1,1,3,1,2,2,1,1,3
	sourceList2 BYTE 3,2,3,1,1,3,3,2,2,1,2,3,3,2,3,1,1,3,1,2,2,1,1,3,3,2,3,1,1,3,1,2,2
	sourceList3 BYTE 1,2,3,3,2,2,1,1,3,1,2,2,1,2,3,3,2,3,1,1,3,3,2,2,1,2,3,3,2,2,1,1,3
	sourceList4 BYTE 1,2,2,1,1,3,3,2,3,1,1,3,1,2,2,1,2,3,3,2,2,1,1,3,1,2,2,1
	destinList1 BYTE 3,2,2,3,1,3,3,2,2,1,1,2,3,2,2,3,1,3,3,1,2,1,1,3,3,2,2,3,1,3,3,2,2
	destinList2 BYTE 1,1,2,3,2,2,1,1,3,3,1,2,1,1,2,3,2,2,3,1,3,3,2,2,1,1,2,3,2,2,3,1,3
	destinList3 BYTE 3,1,2,1,1,3,3,2,2,3,1,3,3,1,2,1,1,2,3,2,2,1,1,3,3,1,2,1,1,3,3,2,2
	destinList4 BYTE 3,1,3,3,2,2,1,1,2,3,2,2,3,1,3,3,1,2,1,1,3,3,2,2,3,1,3,3
	diskMsg BYTE "Enter the number of disks you wish to play with: ", 0
	selectSrcMsg BYTE "Select your source tower:",0Ah,0DH,0
	selectDstnMsg BYTE "Select your destination tower:",0Ah,0DH,0
	choicesMsg BYTE " ",0DH,0AH
	optionsMsg1 BYTE "      .------------.    .------------.    .----------.",0DH,0AH
	optionsMsg2 BYTE "      |   SOLVE    |    |   RESTART  |    |   QUIT   |",0DH,0AH
	optionsMsg3 BYTE "      `------------'    `------------'    `----------'",0
	wrongInputMsg BYTE "Your input is invalid, please try again.",0DH,0AH,0
	victoryMsg BYTE "Congratulations! You won!",0DH,0AH,0
	gaveUpMsg BYTE "Congratulations! I won!",0DH,0AH,0
	timeMsg BYTE "Your completion time(milliseconds): ",0
	myTimeMsg BYTE "My completion time(milliseconds): ",0
	moveMsg BYTE "Move count: ",0
	errorMsg BYTE "The number must be from 3 to 7.",0DH,0AH,0
	againMsg BYTE "Would you like to play again?",0DH,0AH
	skipline1 BYTE " ",0DH,0AH
	yesNoMsg1 BYTE "       .---------.   .--------.",0DH,0AH
	yesNoMsg2 BYTE "       |   YES   |   |   NO   |",0DH,0AH
	yesNoMsg3 BYTE "       `---------'   `--------'",0
	thankYouMsg BYTE "Thanks for playing. Good bye!",0DH,0AH,0
	minMsg BYTE "You completed the game in the minimum number of moves!",0
	meMinMsg BYTE "I completed the game in the minumum number of moves!",0
	highMsg1 BYTE "The minimum number of moves for ",0
	highMsg2 BYTE " disks is ",0
	highMsg3 BYTE ".",0
	endMsg BYTE "Press any key to continue . . .",0
	restartChar BYTE 'r'
	quitChar BYTE 'q'
	yesMsg BYTE 'y'
	disks DWORD ?

	newtower BYTE 9
	discchar BYTE '='
	towerchar BYTE 124

	count BYTE ?
	counter DWORD 0
	userMove BYTE 4 DUP (0)
	userPick BYTE ?
	srcTower BYTE ?
	dstnTower BYTE ?

	towerApos DWORD ?
	towerBpos DWORD ?
	towerCpos DWORD ?

	valueA DWORD ?
	valueB DWORD ?
	valueC DWORD ?

	compare BYTE ?

	moveCount DWORD 0
	startTime DWORD ?
	total BYTE 0

	yClick BYTE 0
	xClick BYTE 0
	wrongBool BYTE 0
	solvBool BYTE 0

; Point-and-Click code used in .data and .code sections provided by:
; Alex Finn & Deema Alswaimil
;****************************************
		stdInHandle DWORD ?
		bytesRead   DWORD 0
		_INPUT_RECORD STRUCT 
			EventType WORD ?
			WORD ? ; For alignment
			UNION
			KeyEvent KEY_EVENT_RECORD <>
			MouseEvent MOUSE_EVENT_RECORD <>
			WindowBufferSizeEvent WINDOW_BUFFER_SIZE_RECORD <>
			MenuEvent MENU_EVENT_RECORD <>
			FocusEvent FOCUS_EVENT_RECORD <>
			ENDS
	_INPUT_RECORD ENDS
		InputRecord _INPUT_RECORD <>
;****************************************

.code
main PROC
	call GetMSeconds
	mov startTime, eax
	mov moveCount, 0
	mov counter,0
	mov eax, 0
	mov esi, 0
	mov edi, 0
	mov edx, 0
	mov wrongBool, 0
	mov solvBool, 0

	mov edx, OFFSET diskMsg
	Call WriteString

	mov esi, OFFSET towerA
	mov edi, OFFSET towerB
	mov edx, OFFSET towerC
	add esi, 6
	add edi, 6
	add edx, 6

	Call ReadChar
	sub al, 48
	movzx eax, al
	mov disks, eax
	call clrscr
	cmp disks, 3
	jl error
	cmp disks, 7
	jg error
	jmp noError
	error:
		call clrScr
		mov edx, OFFSET errorMsg
		call WriteString
		call main
	noError:
	mov ecx, 7
	mov eax, 0
	mov ebx, disks
	InitialTowerBuild:
		
		mov [esi], bl
		sub esi, TYPE towerA
		mov [edi], al
		sub edi, TYPE towerB
		mov [edx], al
		sub edx, TYPE towerC
		cmp bl, 0
		je skip
		dec bl
		skip:

	Loop InitialTowerBuild

	Call TowerPrint
	call crlf
	mov edx, OFFSET moveMsg
	Call WriteString
	mov eax, moveCount
	Call WriteDec
	Call crlf
	Call crlf
	Call crlf
	Call InitialTowerLocations
	mov ecx, 7
	Game:
	Call userInput
	Call Clrscr
	Call Movedisks
	Call TowerPrint
	Call crlf
	inc moveCount
	mov edx, OFFSET moveMsg
	Call WriteString
	mov eax, moveCount
	Call WriteDec
	Call crlf
	Call VictoryCheck
Loop Game


main ENDP
;********* TOWER BASE POSITIONS *************
InitialTowerLocations PROC

	mov esi,OFFSET towerA
	add esi, 6
	mov eax, disks
	dec eax
	sub esi, eax
	mov towerApos, esi

	mov edi,OFFSET towerB
	add edi, 6
	mov towerBpos, edi

	mov edx,OFFSET towerC
	add edx, 6
	mov towerCpos, edx

ret
InitialTowerLocations ENDP

;************** USER INPUT ******************
userInput PROC
	mov srcTower,0
	mov dstnTower,0

	mov ecx,3
	srcLoop:
		mov al,srcTower
		cmp al,0
		je noSrcSet
		jmp dstnLoop
		noSrcSet:
		call setSource
		inc ecx
		loop srcLoop
	dstnLoop:
		mov al,dstnTower
		cmp al,0
		je noDstnSet
		jmp srcAndDstnSet
		noDstnSet:
		call setDestination
		inc ecx
		loop dstnLoop
	
	srcAndDstnSet:
	ret

userInput ENDP

;************** SET SOURCE ******************
setSource PROC
		mov edx,OFFSET selectSrcMsg
		call clrscr
		call WriteString
		Call TowerPrint
		Call crlf
		mov edx, OFFSET moveMsg
		Call WriteString
		mov eax, moveCount
		Call WriteDec
		call crlf
		mov edx,OFFSET choicesMsg
		call WriteString
		cmp wrongBool,1
		jne cont
		call wrongInput
		inc moveCount
		mov wrongBool,0
		
			
		cont:
		mov yClick,0
		mov xClick,0

		INVOKE GetStdHandle,STD_INPUT_HANDLE
				mov stdInHandle, eax
				invoke SetConsoleMode, stdInHandle, ENABLE_MOUSE_INPUT 

				invoke FlushConsoleInputBuffer, stdInHandle

				mov bytesRead, 0
			.while TRUE
				INVOKE ReadConsoleInput, stdInHandle, ADDR InputRecord, 20, ADDR bytesRead
				.if bytesRead > 0 && InputRecord.EventType == MOUSE_EVENT && InputRecord.MouseEvent.dwButtonState == 1h
							mov eax, 0
							mov al, byte ptr InputRecord.MouseEvent.dwMousePosition.Y
							mov yClick,al
							mov al, byte ptr InputRecord.MouseEvent.dwMousePosition.X
							mov xClick,al
							jmp checkSrcClick
				.endif
					call delay
				
			.endw

		checkSrcClick:
		mov al,yClick
		movzx eax,al

		cmp al, 1
		jl endOfSrcProc
		cmp al, 9
		jg checkSrcSRQ
		
		mov al, xClick
		movzx eax,al

		cmp al, 4;................Check if Tower 1
		jl endOfSrcProc
		cmp al, 20
		jg checkT2
		mov srcTower,1
		jmp endOfSrcProc
		checkT2:;.................Check if Tower 2
		cmp al, 29
		jl endOfSrcProc
		cmp al, 45
		jg checkT3
		mov srcTower,2
		jmp endOfSrcProc
		checkT3:;.................Check if Tower 3
		cmp al, 54
		jl endOfSrcProc
		cmp al, 70
		jg endOfSrcProc
		mov srcTower,3

		checkSrcSRQ:
		mov al,yClick
		movzx eax,al
		cmp al, 12
		jl endOfSrcProc
		cmp al, 14
		jg endOfSrcProc

		mov al,xClick
		movzx eax,al
		checkSolve:;.................Check if Solve button
		cmp al, 6
		jl endOfSrcProc
		cmp al, 19
		jg checkRestart
		call Solver
		checkRestart:;...............Check if Restart button
		cmp al, 24
		jl endOfSrcProc
		cmp al, 37
		jg checkQuit
		call clrscr
		
		call main
		checkQuit:;..................Check if Quit button
		cmp al, 42
		jl endOfSrcProc
		cmp al, 53
		jg endOfSrcProc
		call clrscr
		mov edx, OFFSET thankYouMsg
		call WriteString
		call Crlf
		mov edx, OFFSET endMsg
		call WriteString
		call readChar
		exit


		endOfSrcProc:
		ret

setSource ENDP

;************** SET Destination ******************
setDestination PROC
		mov edx,OFFSET selectDstnMsg
		call clrscr
		call WriteString
		Call TowerPrint
		Call crlf
		mov edx, OFFSET moveMsg
		Call WriteString
		mov eax, moveCount
		Call WriteDec
		call crlf
		mov edx,OFFSET choicesMsg
		call WriteString

		mov yClick,0
		mov xClick,0

		INVOKE GetStdHandle,STD_INPUT_HANDLE
				mov stdInHandle, eax
				invoke SetConsoleMode, stdInHandle, ENABLE_MOUSE_INPUT 

				invoke FlushConsoleInputBuffer, stdInHandle

				mov bytesRead, 0
				; Wait for user input
				.while TRUE
					INVOKE ReadConsoleInput, stdInHandle, ADDR InputRecord, 20, ADDR bytesRead ; picking up movement, have to read for click
					.if bytesRead > 0 && InputRecord.EventType == MOUSE_EVENT && InputRecord.MouseEvent.dwButtonState == 1h
							mov eax,0
							mov al, byte ptr InputRecord.MouseEvent.dwMousePosition.Y
							mov yClick,al
							mov al, byte ptr InputRecord.MouseEvent.dwMousePosition.X
							mov xClick,al
							jmp checkDstnClick

					.endif
					call delay
				
				.endw

		checkDstnClick:
		mov al,yClick
		movzx eax,al

		cmp al, 1
		jl endOfDstnProc
		cmp al, 9
		jg checkDstnSRQ
		
		mov al, xClick
		movzx eax,al

		cmp al, 4;................Check if Tower 1
		jl endOfDstnProc
		cmp al, 20
		jg checkT2
		mov DstnTower,1
		jmp endOfDstnProc
		checkT2:;.................Check if Tower 2
		cmp al, 29
		jl endOfDstnProc
		cmp al, 45
		jg checkT3
		mov DstnTower,2
		jmp endOfDstnProc
		checkT3:;.................Check if Tower 3
		cmp al, 54
		jl endOfDstnProc
		cmp al, 70
		jg endOfDstnProc
		mov DstnTower,3

		checkDstnSRQ:
		mov al,yClick
		movzx eax,al
		cmp al, 12
		jl endOfDstnProc
		cmp al, 14
		jg endOfDstnProc

		mov al,xClick
		movzx eax,al
		checkSolve:;.................Check if Solve button
		cmp al, 6
		jl endOfDstnProc
		cmp al, 19
		jg checkRestart
		call Solver
		checkRestart:;...............Check if Restart button
		cmp al, 24
		jl endOfDstnProc
		cmp al, 37
		jg checkQuit
		call clrscr
		call main
		checkQuit:;..................Check if Quit button
		cmp al, 42
		jl endOfDstnProc
		cmp al, 53
		jg endOfDstnProc
		call clrscr
		mov edx, OFFSET thankYouMsg
		call WriteString
		call Crlf
		mov edx, OFFSET endMsg
		call WriteString
		call readChar
		exit


		endOfDstnProc:
		ret

setDestination ENDP

;**************** MOVE DISKS *************
Movedisks PROC

	cmp srcTower,1
	je startAtA
	cmp srcTower,2
	je startAtB
	cmp srcTower,3
	je startAtC

	call wrongInput
	ret

	startAtA:

		cmp dstnTower, 2
		je EndAtB
		cmp dstnTower, 3
		je EndAtC

		Call WrongInput
		ret
		EndAtB:


			mov esi, towerApos
			mov edi, towerBpos
			mov al, [esi]
			mov bl, [edi+1]
			mov compare, bl
			cmp al, 0
			je wrongInput
			cmp compare, 0
			je go1
			cmp compare, al
			jl wrongInput
			go1:
			mov [edi], al
			mov al, 0
			mov [esi], al
			add towerApos, TYPE towerA
			mov valueA, esi
			mov valueB, edi
			sub towerBpos, TYPE towerB
			ret



		EndAtC:

			mov esi, towerApos
			mov edx, towerCpos
			mov al, [esi]
			mov bl, [edx+1]
			mov compare, bl
			cmp al, 0
			je wrongInput
			cmp compare, 0
			je go2
			cmp compare, al
			jl wrongInput
			go2:
			mov [edx], al
			mov al, 0
			mov [esi], al
			add towerApos, TYPE towerA
			mov valueA, esi
			mov valueC, edx
			sub towerCpos, TYPE towerC
			ret

	startAtB:
		mov edi, OFFSET towerB
		add edi, 6
		cmp dstnTower, 1
		je EndAtA
		cmp dstnTower, 3
		je FineAtC

		Call WrongInput
		ret
		EndAtA:
			mov esi, towerApos
			mov edi, towerBpos

			add edi, TYPE towerB
			sub esi, TYPE towerA
			mov al, [edi]
			mov bl, [esi+1]
			mov compare, bl
			cmp al, 0
			je wrongInput
			cmp compare, 0
			je go3
			cmp compare, al
			jl wrongInput
			go3:
			mov [esi], al
			mov al, 0
			mov [edi], al

			mov valueA, esi
			mov valueB, edi

			mov towerApos, esi
			mov towerBpos, edi


		ret
		FineAtC:

			mov edi, towerBpos
			mov edx, towerCpos

			add edi, TYPE towerB
			mov al, [edi]
			mov bl, [edx+1]
			mov compare, bl
			cmp al, 0
			je wrongInput
			cmp compare, 0
			je go4
			cmp compare, al
			jl wrongInput
			go4:
			mov [edx], al

			mov al, 0
			mov [edi], al

			mov valueB, edi
			mov valueC, edx
			sub edx, TYPE towerC

			mov towerBpos, edi
			mov towerCpos, edx
		ret
	startAtC:
		mov al, 0
		movzx eax, al
		mov edx, OFFSET towerC
		add edx, 6
		cmp dstnTower, 1
		je FineAtA
		cmp dstnTower, 2
		je FineAtB

		Call WrongInput
		ret
		FineAtA:

			mov esi, towerApos
			mov edx, towerCpos

			add edx, TYPE towerC
			sub esi, TYPE towerA
			mov al, [edx]
			mov bl, [esi+1]
			mov compare, bl
			cmp al, 0
			je wrongInput
			cmp compare, 0
			je go5
			cmp compare, al
			jl wrongInput
			go5:
			mov [esi], al
			mov al, 0
			mov [edx], al

			mov valueA, esi
			mov valueC, edx

			mov towerApos, esi
			mov towerCpos, edx
		ret
		FineAtB:

			mov edi, towerBpos
			mov edx, towerCpos

			add edx, TYPE towerC
			mov al, [edx]
			mov bl, [edi+1]
			mov compare, bl
			cmp al, 0
			je wrongInput
			cmp compare, 0
			je go6
			cmp compare, al
			jl wrongInput
			go6:
			mov [edi], al

			mov al, 0
			mov [edx], al

			mov valueB, edi
			mov valueC, edx
			sub edi, TYPE towerC

			mov towerBpos, edi
			mov towerCpos, edx
		ret

	ret
Movedisks ENDP

;********** PRINT TOWER A *****************
PrintTA PROC USES esi
	
mov al, [esi]
	cmp al, 0
	je zeroA

	mov bl, 12
	sub bl, al
	mov cl, bl
	spacing1:
		mov al, ' '
		call WriteChar
	loop spacing1

	mov al, [esi]
	add al, al
	add al, 1
	mov cl, al
	mov al, [esi]
	add al, 8
	call setTextColor
	BuildTowerA:
		mov al, discchar
		Call WriteChar
	Loop BuildTowerA
	mov al, lightgray
	call setTextColor
	
	mov al, [esi]
	mov bl, 12
	sub bl, al
	mov cl, bl
	spacing3:
		mov al, ' '
		call WriteChar
	loop spacing3

	jmp contA
	zeroA:
		mov bl, 12
		mov cl, bl
		spacing2:
			mov al, ' '
			call WriteChar
		loop spacing2
		mov al, towerchar
		Call WriteChar
		mov bl, 12
		mov cl, bl
		spacing4:
			mov al, ' '
			call WriteChar
		loop spacing4

	contA:
	ret
PrintTA ENDP

;********** PRINT TOWER B *****************
PrintTB PROC USES edi

mov al, [edi]
	cmp al, 0
	je zeroB

	mov bl, 12
	sub bl, al
	mov cl, bl
	spacing1:
		mov al, ' '
		call WriteChar
	loop spacing1

	mov al, [edi]
	add al, al
	add al, 1
	mov cl, al
	mov al, [edi]
	add al, 8
	call setTextColor
	BuildTowerB:
		mov al, discchar
		Call WriteChar
	Loop BuildTowerB
	mov al, lightgray
	call setTextColor

	mov al, [edi]
	mov bl, 12
	sub bl, al
	mov cl, bl
	spacing3:
		mov al, ' '
		call WriteChar
	loop spacing3

	jmp contB
	zeroB:
		mov bl, 12
		mov cl, bl
		spacing2:
			mov al, ' '
			call WriteChar
		loop spacing2
		mov al, towerchar
		Call WriteChar
		mov bl, 12
		mov cl, bl
		spacing4:
			mov al, ' '
			call WriteChar
		loop spacing4

	contB:
	ret
PrintTB ENDP

;********** PRINT TOWER C *****************
PrintTC PROC USES edx

mov al, [edx]
	cmp al, 0
	je zeroC

	mov bl, 12
	sub bl, al
	mov cl, bl
	spacing1:
		mov al, ' '
		call WriteChar
	loop spacing1

	mov al, [edx]
	add al, al
	add al, 1
	mov cl, al
	mov al, [edx]
	add al, 8
	call setTextColor
	BuildTowerC:
		mov al, discchar
		Call WriteChar
	Loop BuildTowerC
	mov al, lightgray
	call setTextColor

	mov al, [edx]
	mov bl, 12
	sub bl, al
	mov cl, bl
	spacing3:
		mov al, ' '
		call WriteChar
	loop spacing3

	jmp contC
	zeroC:
		mov bl, 12
		mov cl, bl
		spacing2:
			mov al, ' '
			call WriteChar
		loop spacing2
		mov al, towerchar
		Call WriteChar
		mov bl, 12
		mov cl, bl
		spacing4:
			mov al, ' '
			call WriteChar
		loop spacing4

	contC:
	ret
PrintTC ENDP

;*************** PRINT ALL TOWERS *************************
TowerPrint PROC

	mov esi, OFFSET towerA
	mov edi, OFFSET towerB
	mov edx, OFFSET towerC
	Call crlf
	mov ecx, lengthof towerA

	TowersPrint:
	mov count, cl
	Call PrintTA
	Call PrintTB
	Call PrintTC

		Call Crlf

		inc esi
		inc edi
		inc edx

	mov cl, count
	Loop TowersPrint

ret
TowerPrint ENDP

;************ VICTORY CHECK *****************
VictoryCheck PROC

	mov total, 0
	mov eax, 0
	mov esi, OFFSET towerA
	mov ecx, 7
	adding1:
		mov al, [esi]
		add total, al
		inc esi
	loop adding1

	mov edi, OFFSET towerB
	mov ecx, 7
	adding2:
		mov al, [edi]
		add total, al
		inc edi
	loop adding2
	call crlf
	cmp total, 0
	jne no
	call Victory

	no:
	mov total, 0
	mov eax, 0
	mov esi, OFFSET towerA
	mov ecx, 7
	adding3:
		mov al, [esi]
		add total, al
		inc esi
	loop adding3

	mov edi, OFFSET towerC
	mov ecx, 7
	adding4:
		mov al, [edi]
		add total, al
		inc edi
	loop adding4
	call crlf
	cmp total, 0
	jne keepPlaying
	call Victory

	keepPlaying:
ret
VictoryCheck ENDP

;*************** VICTORY *******************
Victory PROC
	call Crlf
	.IF disks == 3
		mov ebx, 7
	.ELSEIF disks == 4
		mov ebx, 15
	.ELSEIF disks == 5
		mov ebx, 31
	.ELSEIF disks == 6
		mov ebx, 63
	.ELSEIF disks == 7
		mov ebx, 127
	.ENDIF

	cmp solvBool,1
	je loser
	mov edx, OFFSET victoryMSG
	call WriteString
	call crlf
	jmp moveCounting
	loser:
	mov edx, OFFSET gaveUpMsg
	call WriteString
	call crlf
	moveCounting:
	cmp moveCount, ebx
	je minimum
	mov edx, OFFSET highMsg1
	call WriteString
	mov eax, disks
	call WriteDec
	mov edx, OFFSET highMsg2
	mov eax, ebx
	call WriteString
	call WriteDec
	mov al, '.'
	call WriteChar
	call crlf
	call crlf
	jmp higher
	minimum:
		cmp solvBool,1
		je fastComp 
		mov edx, OFFSET minMsg
		call WriteString
		call Crlf
		call Crlf
		jmp higher
		fastComp:
		mov edx, OFFSET meMinMsg
		call WriteString
		call Crlf
		call Crlf
	higher:
	cmp solvBool,1
	je myTime
	mov edx, OFFSET timeMsg
	call WriteString
	jmp done
	myTime:
	mov edx, OFFSET myTimeMsg
	call WriteString
	done:
	call GetMSeconds
	sub eax, startTime
	call WriteDec ;display the value in EAX
	call crlf
	call crlf
	call playAgain
Victory ENDP

;************* WRONG INPUT *******************
wrongInput Proc
	mov wrongBool,1
	mov dl, 0
	mov dh, 24
	mov eax, lightred
	call gotoXY
	call setTextColor
	mov edx,OFFSET wrongInputMsg
	call WriteString
	mov dl,79
	mov dh,0
	call gotoXY
	dec moveCount
	mov eax, lightgray
	call setTextColor
	ret
wrongInput ENDP

;************* PLAY AGAIN? *******************
playAgain Proc
	mov edx,OFFSET againMsg
	call WriteString

	mov ecx,3
	finalLoop:
	call checkFinalClick
	inc ecx
	loop finalLoop

playAgain ENDP

;*********** CHECK FINAL DECISION ****************
checkFinalClick PROC
	mov yClick,0
	mov xClick,0

INVOKE GetStdHandle,STD_INPUT_HANDLE
		mov stdInHandle, eax
		invoke SetConsoleMode, stdInHandle, ENABLE_MOUSE_INPUT 

		invoke FlushConsoleInputBuffer, stdInHandle

		mov bytesRead, 0
		.while TRUE
			INVOKE ReadConsoleInput, stdInHandle, ADDR InputRecord, 20, ADDR bytesRead ; picking up movement, have to read for click
			.if bytesRead > 0 && InputRecord.EventType == MOUSE_EVENT && InputRecord.MouseEvent.dwButtonState == 1h
					mov eax,0
					mov al, byte ptr InputRecord.MouseEvent.dwMousePosition.Y
					mov yClick,al
					mov al, byte ptr InputRecord.MouseEvent.dwMousePosition.X
					mov xClick,al
					jmp checkClick

			.endif
			call delay
				
		.endw

	checkClick:
		mov al,yClick
		movzx eax,al

		cmp al, 20
		jl repeatCheck
		cmp al, 22
		jg repeatCheck
		
		mov al, xClick
		movzx eax,al

		cmp al, 6;................Check if Yes
		jl repeatCheck
		cmp al, 18
		jg checkNo
		jmp restart
		checkNo:;.................Check if No
		cmp al, 20
		jl repeatCheck
		cmp al, 31
		jg repeatCheck
		jmp quit

	restart:
		call clrscr
		call main
	quit:
		call clrscr
		mov edx, OFFSET thankYouMsg
		call WriteString
		call Crlf
		mov edx, OFFSET endMsg
		call WriteString
		call readChar
		exit

repeatCheck:
ret
checkFinalClick ENDP

;************** SOLVER ****************
Solver PROC
	
	mov solvBool,1
	call GetMSeconds
	mov startTime, eax
	mov moveCount, 0
	mov eax, 0
	mov esi, 0
	mov edi, 0
	mov edx, 0

	mov esi, OFFSET towerA
	mov edi, OFFSET towerB
	mov edx, OFFSET towerC
	add esi, 6
	add edi, 6
	add edx, 6

	call clrscr
	mov ecx, 7
	mov eax, 0
	mov ebx, disks
	InitialTowerBuild:
		
		mov [esi], bl
		sub esi, TYPE towerA
		mov [edi], al
		sub edi, TYPE towerB
		mov [edx], al
		sub edx, TYPE towerC
		cmp bl, 0
		je skip
		dec bl
		skip:

	Loop InitialTowerBuild

	Call TowerPrint
	Call crlf
	mov edx, OFFSET moveMsg
	Call WriteString
	mov eax, moveCount
	Call WriteDec
	Call crlf
	Call crlf
	Call crlf
	Call InitialTowerLocations
	mov ecx, 7
	Game:
		mov eax, 400
		Call Delay
		Call Clrscr
		Call Algorithm
		Call MoveDisks
		Call TowerPrint
		Call crlf
		inc moveCount
		mov edx, OFFSET moveMsg
		Call WriteString
		mov eax, moveCount
		Call WriteDec
		Call crlf
		Call VictoryCheck
		inc counter
	Loop Game
Solver ENDP

;************** ALGORITHM *************
Algorithm PROC

	mov esi, OFFSET sourceList1
	mov edi, OFFSET destinList1
	add esi, counter
	add edi, counter
	mov eax, [esi]
	mov ebx, [edi]
	mov srcTower, al
	mov dstnTower, bl
	ret

Algorithm ENDP

END main