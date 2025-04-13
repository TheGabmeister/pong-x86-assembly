; Pong Game
; Modified version of https://github.com/arham2211/ping-pong-x86-game

; Library from the book Assembly Language for x86 Processors by Kip Irvine
; https://github.com/surferkip/asmbook/blob/main/Irvine.zip
; Documentation https://csc.csudh.edu/mmccullough/asm/help/
INCLUDE Irvine32.inc

.data

GAME_SPEED DWORD 45				;Change this if the game is running too fast or too slow
BALL_X BYTE 14                  ;moves row
BALL_Y BYTE 39					;moves column
COUNT BYTE 1

BALL_VELOCITY_X BYTE 1
BALL_VELOCITY_Y BYTE 1 

PADDLE_LEFT_X BYTE 1                 
PADDLE_LEFT_Y BYTE 1

ORIGINAL_PADDLE_LEFT_X BYTE ?                
ORIGINAL_PADDLE_LEFT_Y BYTE ?
VAL1 BYTE 1
VAL2 BYTE 7

PADDLE_RIGHT_X BYTE 1     
PADDLE_RIGHT_Y BYTE 77

ORIGINAL_PADDLE_RIGHT_X BYTE ?                
ORIGINAL_PADDLE_RIGHT_Y BYTE ?
VAL3 BYTE 1
VAL4 BYTE 7

GAME_START_FLAG BYTE 0  ;flag to determine if the game should start 

STRING_PRESS_ENTER BYTE "Hold 'ENTER' to Start",0
STRING_PRESS_ENTER_X BYTE 50
STRING_PRESS_ENTER_Y BYTE 25
xPos BYTE 17
yPos BYTE 3

; Define an array of strings with newline characters at the end
GAME_TITLE DWORD TITLE_01, TITLE_02, TITLE_03, TITLE_04, TITLE_05, TITLE_06, TITLE_07, TITLE_08, TITLE_09, TITLE_10, TITLE_11, TITLE_12, TITLE_13, TITLE_14, TITLE_15, TITLE_16
TITLE_01 BYTE "PPPPPPPPPPPPPPPPP        OOOOOOOOO     NNNNNNNN        NNNNNNNN        GGGGGGGGGGGGG",  0
TITLE_02 BYTE "P::::::::::::::::P     OO:::::::::OO   N:::::::N       N::::::N     GGG::::::::::::G",  0
TITLE_03 BYTE "P::::::PPPPPP:::::P  OO:::::::::::::OO N::::::::N      N::::::N   GG:::::::::::::::G",  0
TITLE_04 BYTE "PP:::::P     P:::::PO:::::::OOO:::::::ON:::::::::N     N::::::N  G:::::GGGGGGGG::::G",  0
TITLE_05 BYTE "  P::::P     P:::::PO::::::O   O::::::ON::::::::::N    N::::::N G:::::G       GGGGGG",  0
TITLE_06 BYTE "  P::::P     P:::::PO:::::O     O:::::ON:::::::::::N   N::::::NG:::::G              ",  0
TITLE_07 BYTE "  P::::PPPPPP:::::P O:::::O     O:::::ON:::::::N::::N  N::::::NG:::::G              ",  0
TITLE_08 BYTE "  P:::::::::::::PP  O:::::O     O:::::ON::::::N N::::N N::::::NG:::::G    GGGGGGGGGG",  0
TITLE_09 BYTE "  P::::PPPPPPPPP    O:::::O     O:::::ON::::::N  N::::N:::::::NG:::::G    G::::::::G",  0
TITLE_10 BYTE "  P::::P            O:::::O     O:::::ON::::::N   N:::::::::::NG:::::G    GGGGG::::G",  0
TITLE_11 BYTE "  P::::P            O:::::O     O:::::ON::::::N    N::::::::::NG:::::G        G::::G",  0
TITLE_12 BYTE "  P::::P            O::::::O   O::::::ON::::::N     N:::::::::N G:::::G       G::::G",  0
TITLE_13 BYTE "PP::::::PP          O:::::::OOO:::::::ON::::::N      N::::::::N  G:::::GGGGGGGG::::G",  0
TITLE_14 BYTE "P::::::::P           OO:::::::::::::OO N::::::N       N:::::::N   GG:::::::::::::::G",  0
TITLE_15 BYTE "P::::::::P             OO:::::::::OO   N::::::N        N::::::N     GGG::::::GGG:::G",  0
TITLE_16 BYTE "PPPPPPPPPP               OOOOOOOOO     NNNNNNNN         NNNNNNN        GGGGGG   GGGG",  0
TITLE_ANIM_SPEED DWORD 90

; =========================================================================================================

 WIN1 BYTE "                   _____  _           __     ________ _____     __   __          _______ _   _  _____     ",0
 WIN2 BYTE "                  |  __ \| |        /\\ \   / /  ____|  __ \   /_ |  \ \        / /_   _| \ | |/ ____|	",0
 WIN3 BYTE "                  | |__) | |       /  \\ \_/ /| |__  | |__) |   | |   \ \  /\  / /  | | |  \| | (___		",0
 WIN4 BYTE "                  |  ___/| |      / /\ \\   / |  __| |  _  /    | |    \ \/  \/ /   | | | . ` |\___ \	    ",0
 WIN5 BYTE "                  | |    | |____ / ____ \| |  | |____| | \ \    | |     \  /\  /   _| |_| |\  |____) |	",0
 WIN6 BYTE "                  |_|    |______/_/    \_\_|  |______|_|  \_\   |_|      \/  \/   |_____|_| \_|_____/	    ",0
                                                                                     

 LOST1 BYTE "                   _____  _           __     ________ _____     __     __          _______ _   _  _____     ",0
 LOST2 BYTE "                  |  __ \| |        /\\ \   / /  ____|  __ \   |__ \   \ \        / /_   _| \ | |/ ____|	",0
 LOST3 BYTE "                  | |__) | |       /  \\ \_/ /| |__  | |__) |     ) |   \ \  /\  / /  | | |  \| | (___		",0
 LOST4 BYTE "                  |  ___/| |      / /\ \\   / |  __| |  _  /     / /     \ \/  \/ /   | | | . ` |\___ \	    ",0
 LOST5 BYTE "                  | |    | |____ / ____ \| |  | |____| | \ \    / /_      \  /\  /   _| |_| |\  |____) |	",0
 LOST6 BYTE "                  |_|    |______/_/    \_\_|  |______|_|  \_\   |____|     \/  \/   |_____|_| \_|_____/	    ",0                                                    
																		   


Player1_Score BYTE "PLAYER 1 Points: ",0
Player2_Score BYTE "PLAYER 2 Points: ",0
PLAYER1 BYTE 0
PLAYER2 BYTE 0

PLAYER_1 BYTE 30 DUP(?)
PLAYER_2 BYTE 30 DUP(?)
LENGTH_PLAYER1 BYTE ?
LENGTH_PLAYER2 BYTE ?

INPUT_PLAYER_1 BYTE "Enter Player 1's Name: ",0
INPUT_PLAYER_2 BYTE "Enter Player 2's Name: ",0

BOX_TOP_LEFT_X BYTE 0
BOX_TOP_LEFT_Y BYTE 0

PlAYER_CURSOR_X BYTE 19
PlAYER_CURSOR_Y BYTE 42

NEXT_LINE BYTE 0dh,0ah

; =========================================================================================================

.code
main PROC

call mainMenu  ;display menu
cmp GAME_START_FLAG, 0 
je Exitprogram

mov eax,0
mov edx,0
call DRAW_BALL
call DRAW_LEFT_PADDLES
call DRAW_TEXT
;call DRAW_BOX
CHECK_TIME:

call CLEAR_SCREEN
call MOVE_BALL
call DRAW_BALL
call MOVE_PADDLES
call DRAW_LEFT_PADDLES
call DRAW_RIGHT_PADDLES
call DRAW_TEXT
cmp COUNT,0
jne CHECK_TIME
call clrscr
cmp PLAYER1,2
jne PLAYER2_WINNING
call PLAYER1_WINS
jmp stop

PLAYER2_WINNING:
call PLAYER2_WINS

stop:
	mov eax, 5000
	call delay
	exit

Exitprogram:
	invoke Exitprocess, 0

main ENDP

; =========================================================================================================

PLAYER2_WINS PROC

	mov eax, LIGHTCYAN
	call SetTextColor

	mov edx, OFFSET LOST1
    call WriteString
    call Crlf

	mov edx, OFFSET LOST2
    call WriteString
    call Crlf

	mov edx, OFFSET LOST3
    call WriteString
    call Crlf

	mov edx, OFFSET LOST4
    call WriteString
    call Crlf

	mov edx, OFFSET LOST5
    call WriteString
    call Crlf

	mov edx, OFFSET LOST6
    call WriteString
    call Crlf

RET
PLAYER2_WINS ENDP

; =========================================================================================================

PLAYER1_WINS PROC

	mov eax, YELLOW
	call SetTextColor
    
	mov edx, OFFSET WIN1
    call WriteString
    call Crlf

	mov edx, OFFSET WIN2
    call WriteString
    call Crlf

	mov edx, OFFSET WIN3
    call WriteString
    call Crlf

	mov edx, OFFSET WIN4
    call WriteString
    call Crlf

	mov edx, OFFSET WIN5
    call WriteString
    call Crlf

	mov edx, OFFSET WIN6
    call WriteString
    call Crlf

RET
PLAYER1_WINS ENDP

; =========================================================================================================

mainMenu PROC
    
	mov eax, YELLOW
    call SetTextColor

	mov esi, OFFSET GAME_TITLE
    mov ecx, LENGTHOF GAME_TITLE
    mov bl, xPos
    mov bh, yPos

    L1:									; Print game title
		mov eax, TITLE_ANIM_SPEED		; Add a delay per line for a cool animation
		call delay
		mov dl, bl
		mov dh, bh
		call Gotoxy
		mov edx, [esi]
		call WriteString
		add esi, TYPE GAME_TITLE
		inc bh
    loop L1

    mov dl, STRING_PRESS_ENTER_X           ; Print "Press 'ENTER' to Start"
    mov dh, STRING_PRESS_ENTER_Y
    call Gotoxy
	mov eax, LIGHTCYAN
    call SetTextColor
    mov edx, OFFSET STRING_PRESS_ENTER
    call WriteString
    call RESET_CURSOR

	MenuLoop:
		call Readkey
		cmp al,13           ; Check if 'ENTER' key (ASCII 13) is pressed  
		jz StartGame
		cmp al,27           ; Check if 'ESC' key (ASCII 13) is pressed 
		jz ExitGame
		jmp MenuLoop

    StartGame:
        mov GAME_START_FLAG, 1   ; Set the flag to 1 indicating the game should start
		call Clrscr
        ret

    ExitGame:
        invoke ExitProcess, 0    ; Exit the program

mainMenu ENDP

; =========================================================================================================

DRAW_BOX PROC
    ; Draw the top-left corner character
    mov dh, BOX_TOP_LEFT_X
    mov dl, BOX_TOP_LEFT_Y
    call Gotoxy
    mov al, '+'
    call WriteChar

    ; Draw the top border
    mov ecx, 34
    L1:
        INC BOX_TOP_LEFT_Y
        mov dh, BOX_TOP_LEFT_X
        mov dl, BOX_TOP_LEFT_Y
        call Gotoxy
        mov al, '-'
        call WriteChar
        LOOP L1

    ; Draw the top-right corner character
    mov al, '+'
    call WriteChar

    ; Draw the right border
    mov ecx, 10
    INC BOX_TOP_LEFT_Y
    L2:
        INC BOX_TOP_LEFT_X
        mov dh, BOX_TOP_LEFT_X
        mov dl, BOX_TOP_LEFT_Y
        call Gotoxy
        mov al, '|'
        call WriteChar
        Loop L2

    ; Draw the bottom-right corner character
	call Gotoxy
    mov al, '+'
    call WriteChar

    ; Draw the bottom border
    mov ecx, 35
   
    L3:
        DEC BOX_TOP_LEFT_Y
        mov dh, BOX_TOP_LEFT_X
        mov dl, BOX_TOP_LEFT_Y
        call Gotoxy
        mov al, '-'
        call WriteChar
        LOOP L3

    ; Draw the bottom-left corner character
	 INC BOX_TOP_LEFT_Y
     call Gotoxy
	 mov al, '+'
	 call WriteChar

    ; Draw the left border
    mov ecx, 9
    DEC BOX_TOP_LEFT_Y
    L4:
        DEC BOX_TOP_LEFT_X
        mov dh, BOX_TOP_LEFT_X
        mov dl, BOX_TOP_LEFT_Y
        call Gotoxy
        mov al, '|'
        call WriteChar
        Loop L4

		ret

 DRAW_BOX ENDP

; =========================================================================================================

DRAW_LEFT_PADDLES PROC
	
	mov dh,PADDLE_LEFT_X
	mov dl,PADDLE_LEFT_Y

	mov ORIGINAL_PADDLE_LEFT_X,dh                
    mov ORIGINAL_PADDLE_LEFT_Y,dl 

	mov eax, YELLOW
    call SetTextColor
	call Gotoxy
	mov al, 0DBh
	call WRITEchar

	mov ecx,6
	L1:
		inc PADDLE_LEFT_X	
		mov dh,PADDLE_LEFT_X
		call Gotoxy
		mov al, 0DBh
	    call WRITEchar
	Loop L1
	
	mov bl,ORIGINAL_PADDLE_LEFT_X
	mov PADDLE_LEFT_X,bl
	mov bl,ORIGINAL_PADDLE_LEFT_Y
	mov PADDLE_LEFT_Y,bl

ret
DRAW_LEFT_PADDLES ENDP

; =========================================================================================================

DRAW_RIGHT_PADDLES PROC

	mov dh,PADDLE_RIGHT_X
	mov dl,PADDLE_RIGHT_Y

	mov ORIGINAL_PADDLE_RIGHT_X,dh                
    mov ORIGINAL_PADDLE_RIGHT_Y,dl 

	mov eax, LIGHTCYAN
    call SetTextColor
	call Gotoxy
	mov al, 0DBh
	call WRITEchar

	mov ecx,6
	L1:
		mov al, 0DBh
		inc PADDLE_RIGHT_X	
		mov dh,PADDLE_RIGHT_X
		call Gotoxy
		call writechar
	Loop L1

	mov bl,ORIGINAL_PADDLE_RIGHT_X
	mov PADDLE_RIGHT_X,bl
	mov bl,ORIGINAL_PADDLE_RIGHT_Y
	mov PADDLE_RIGHT_Y,bl

RET
DRAW_RIGHT_PADDLES ENDP

; =========================================================================================================

MOVE_PADDLES PROC

	call Readkey
	cmp al,'w'
	jz MOVE_LEFT_PADDLE_UP
	
	cmp al,'s'
	jz MOVE_LEFT_PADDLE_DOWN
	
	JMP CHECK_RIGHT_PADDLE_MOVEMENT

RET

MOVE_LEFT_PADDLE_DOWN:
	cmp val2,28
	jae quit

	inc PADDLE_LEFT_X
	mov dh,VAL1
	mov dl,1
	call Gotoxy
	mov al, ' '
	call WRITEchar
	INC VAL1
	INC VAL2

	finish:

RET

MOVE_LEFT_PADDLE_UP:
	cmp VAL1,1
	jbe quit 
	
	dec PADDLE_LEFT_X
	mov dh,VAL2
	mov dl,1
	call Gotoxy
	mov al, ' '
	call WRITEchar
	DEC VAL1
	DEC VAL2

quit:
jmp CHECK_RIGHT_PADDLE_MOVEMENT
RET

CHECK_RIGHT_PADDLE_MOVEMENT:

	cmp al,'o'
	je MOVE_RIGHT_PADDLE_UP

	cmp al,'l'
	je MOVE_RIGHT_PADDLE_DOWN
	jmp EXIT_PADDLE_MOVEMENT

RET

MOVE_RIGHT_PADDLE_DOWN:

	cmp val4,28
	jae EXIT_PADDLE_MOVEMENT 

	inc PADDLE_RIGHT_X
	mov dh,VAL3
	mov dl,77
	call Gotoxy
	mov al, ' '
	call WRITEchar
	INC VAL3
	INC VAL4
RET

MOVE_RIGHT_PADDLE_UP:

	cmp VAL3,1
	jbe EXIT_PADDLE_MOVEMENT 
	dec PADDLE_RIGHT_X
	mov dh,VAL4
	mov dl,77
	call Gotoxy
	mov al, ' '
	call WRITEchar
	DEC VAL3
	DEC VAL4

EXIT_PADDLE_MOVEMENT:
RET
MOVE_PADDLES ENDP

; =========================================================================================================

DRAW_BALL PROC

	mov dh,BALL_X
	mov dl,BALL_Y
	call Gotoxy
	mov eax, WHITE
    call SetTextColor
	mov al,'O'
	call writeChar
		
RET
DRAW_BALL ENDP

; =========================================================================================================

CLEAR_SCREEN PROC

	mov eax, GAME_SPEED			; This controls how fast the game runs
	call delay
	mov dh,BALL_X
	mov dl,BALL_Y
	call Gotoxy
	mov al,' '
	call writeCHar

RET
CLEAR_SCREEN ENDP

; =========================================================================================================

MOVE_BALL PROC

	mov ah,BALL_VELOCITY_X    
	add BALL_X,ah
	
	cmp BALL_X,0
	jbe NEG_VELOCITY_X
	
	cmp BALL_X,29
	jae NEG_VELOCITY_X  
	
	mov al,BALL_VELOCITY_Y    
	add BALL_Y,al
	
	cmp BALL_Y,0
	jbe RESET_POSITION
	
	cmp BALL_Y,78
	jae RESET_POSITION 
	
	CMP BALL_Y,76
	jne CHECK_COLLISION_WITH_LEFT_PADDLE
	mov eax,0
	mov ebx,0

	mov al,BALL_X
	mov bl,PADDLE_RIGHT_X

	cmp BALL_X,bl
	jae RIGHT_PADDLE_COLLIDE_CHECKER

	jmp CHECK_COLLISION_WITH_LEFT_PADDLE

	RIGHT_PADDLE_COLLIDE_CHECKER:
	add bl,7
	cmp BALL_X,bl
	jbe NEG_VELOCITY_Y

	CHECK_COLLISION_WITH_LEFT_PADDLE:

	CMP BALL_Y,2
	jne EXIT_COLLISION_CHECK 
	mov eax,0
	mov ebx,0

	mov al,BALL_X
	mov bl,PADDLE_LEFT_X

	cmp BALL_X,bl
	jae LEFT_PADDLE_COLLIDE_CHECKER

	jmp EXIT_COLLISION_CHECK 

	LEFT_PADDLE_COLLIDE_CHECKER:
	add bl,7
	cmp BALL_X,bl
	jbe NEG_VELOCITY_Y
	jmp EXIT_COLLISION_CHECK 

RET
	
	RESET_POSITION :
	call RESET_BALL_POS
RET
	
	NEG_VELOCITY_X:
	NEG BALL_VELOCITY_X
RET
	
	NEG_VELOCITY_Y:
	NEG BALL_VELOCITY_Y
	EXIT_COLLISION_CHECK:
RET

MOVE_BALL ENDP

; =========================================================================================================

RESET_BALL_POS PROC

cmp BALL_Y,0
jnz player1_scorecard
inc PLAYER2
cmp PLAYER2,2
jne INCREMENT
call GAME_OVER

jmp skip
player1_scorecard:
cmp BALL_Y,77
jb skip
INC PLAYER1
cmp PLAYER1,2
jne INCREMENT
call GAME_OVER
INCREMENT:
call DRAW_TEXT
skip:
	mov BALL_X,14
	mov BALL_Y,39
	mov dh,BALL_X
	mov dl,BALL_Y
	call Gotoxy
	mov al,'O'
	call writeChar

RET
RESET_BALL_POS ENDP

; =========================================================================================================

DRAW_TEXT PROC

mov dh,12
mov dl,87
call Gotoxy
mov edx,OFFSET Player1_Score
mov eax, YELLOW
call SetTextColor
call writeString

mov dh,14
mov dl,87
call Gotoxy

mov edx,OFFSET Player2_Score
mov eax, LIGHTCYAN
call SetTextColor
call writeString

mov dh,12
mov dl,104
call Gotoxy
mov eax, WHITE
call SetTextColor
mov eax,0
mov al,PLAYER1
call writeDec


mov dh,14
mov dl,104
call Gotoxy
mov eax, WHITE
call SetTextColor
mov eax,0
mov al,PLAYER2
call writedec

RET
DRAW_TEXT ENDP

; =========================================================================================================

GAME_OVER PROC

call clrscr

MOV COUNT,0

RET
GAME_OVER ENDP

; =========================================================================================================

RESET_CURSOR PROC
    mov dl, 0
	mov dh, 0
	call Gotoxy
    ret
RESET_CURSOR ENDP

END main