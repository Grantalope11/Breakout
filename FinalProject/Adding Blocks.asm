;-------------------------------------
;   Keyboard and Bufferless VGA Demo Assembly Program
;	Authors: Bridget Benson and Ryan Rumsey
;	Date:	5/4/16
;-------------------------------------

;------------------
;- Port Definitions
;------------------
.EQU	X_POS_EN_ID	= 0xA1	;VGA Controller port X_POS_EN
.EQU	Y_POS_ID	= 0xA2	;VGA Controller port Y_POS
.EQU	RGB_DATA_ID	= 0xA3  ;VGA Controller port RGB_DATA_IN
.EQU	OBJ_ADDR_ID	= 0xA4	;VGA Controller port OBJ_ADDR
.EQU	SSEG_ID		= 0x80  ;Seven Segment Display
.EQU	LEDS_ID		= 0x40  
.EQU	SWITCHES_ID = 0x20
.EQU	BUTTONS_ID  = 0x24
.EQU	PS2_KEY_CODE_ID = 0x30
.EQU	PS2_CONTROL_ID = 0x32

;------------------
;- Bit Masks
;------------------
.EQU	EN_MASK			= 0x80  ;Enable bit is in MSB position of X_POS_EN
.EQU	EN_MASK_OFF		= 0x7F  ;turn off the MSB in X_POS_EN by ANDing
;------------------------------------------------------------------
; Various Keyboard Definitions
;------------------------------------------------------------------
.EQU KEY_UP     = 0xF0        ; key release data
.EQU int_flag   = 0x01        ; interrupt hello from keyboard
.EQU UP       = 0x1D     	  ; 'w' 
.EQU LEFT     = 0x1C     	  ; 'a'
.EQU RIGHT    = 0x23     	  ; 'd'
.EQU DOWN     = 0x1B    	  ; 's'
;------------------------------------------------------------

;------------------
;- Delay Constants
;------------------
.EQU	OUTER_CONST	 = 0x7F
.EQU	MIDDLE_CONST = 0x0F
.EQU	INNER_CONST  = 0x0F
;------------------
;- VGA Boundaries
;------------------
.EQU	MAX_X		= 0xCF  ;Maximum X position  ---> shouldnt this be 7F?
.EQU	MAX_Y		= 0x3B	;Maximum Y position
;------------------
;- Object Memory
;------------------
.EQU	OBJ0_MEM	= 0x00	;Stack address for Object 0 info ---------------------------
.EQU	OBJ1_MEM	= 0x03	;Stack address for Object 1 info
.EQU	OBJ2_MEM	= 0x06	;Stack address for Object 2 info
.EQU	OBJ3_MEM	= 0x09	;Stack address for Object 3 info -------  red blocks  ------
.EQU	OBJ4_MEM	= 0x0C	;Stack address for Object 4 info
.EQU	OBJ5_MEM	= 0x0F	;Stack address for Object 5 info
.EQU	OBJ6_MEM	= 0x12	;Stack address for Object 6 info ---------------------------
.EQU	OBJ7_MEM	= 0x15	;Stack address for Object 7 info ---------------------------
.EQU	OBJ8_MEM	= 0x18	;Stack address for Object 8 info
.EQU	OBJ9_MEM	= 0x1B	;Stack address for Object 9 info
.EQU	OBJ10_MEM	= 0x1E	;Stack address for Object 10 info ----  yellow blocks  -----
.EQU	OBJ11_MEM	= 0x21	;Stack address for Object 11 info
.EQU	OBJ12_MEM	= 0x24	;Stack address for Object 12 info
.EQU	OBJ13_MEM	= 0x27	;Stack address for Object 13 info --------------------------
.EQU	OBJ14_MEM	= 0x2A	;Stack address for Object 14 info --------------------------
.EQU	OBJ15_MEM	= 0x2D	;Stack address for Object 15 info
.EQU	OBJ16_MEM	= 0x30	;Stack address for Object 16 info
.EQU	OBJ17_MEM	= 0x33	;Stack address for Object 17 info ----  green blocks   -----
.EQU	OBJ18_MEM	= 0x36	;Stack address for Object 18 info
.EQU	OBJ19_MEM	= 0x39	;Stack address for Object 19 info
.EQU	OBJ20_MEM	= 0x3C	;Stack address for Object 20 info --------------------------
.EQU	OBJ21_MEM	= 0x3F	;Stack address for Object 21 info --------------------------
.EQU	OBJ22_MEM	= 0x42	;Stack address for Object 22 info
.EQU	OBJ23_MEM	= 0x45	;Stack address for Object 23 info
.EQU	OBJ24_MEM	= 0x48	;Stack address for Object 24 info ----  purple blocks  -----
.EQU	OBJ25_MEM	= 0x4B	;Stack address for Object 25 info
.EQU	OBJ26_MEM	= 0x4E	;Stack address for Object 26 info
.EQU	OBJ27_MEM	= 0x51	;Stack address for Object 27 info --------------------------
.EQU	BALL_MEM	= 0x54	;Stack address for Object 28 info --->>>>> this one is the ball (sorry guys) 

;----------------------
;- Register Definitions
;----------------------
.DEF	R_X_POS_EN	= r0
.DEF	R_Y_POS		= r1
.DEF	R_RGB_DATA	= r2
.DEF	R_OBJ_ADDR	= r3
.DEF	R_ARGUMENT	= r31


.CSEG 
.ORG 0x01

;---------------------------------------------------------------
;-- INIT ALL BLOCKS ------------ 5/25/16------------------------
;-- After we loop through drawing all blocks below 
;-- we drop down to init (below) and draw the ball on the screen
;----------------------------------------------------------------
init blocks: ;enable all blocks
			MOV		R_ARGUMENT, 0x00	;Set up r31 with mem address (starting with 0)
			MOV		R_Y_POS, 	5       ; starting y pos
			MOV		R_X_POS_EN, 5	    ; starting x pos
			MOV		R_OBJ_ADDR, 0x01
			
			
loop_blocks:OR		R_X_POS_EN, EN_MASK			
			CALL	update_obj			
			CALL	set_obj_data			;Store r0-2 into stack at OBJXX_MEM (0 - 28)
			ADD		R_OBJ_ADDR, 0x01		;change to draw the next block
			AND     R_X_POS_EN, EN_MASK_OFF ;turn off the bit mask   
			ADD     R_X_POS_EN, 10      	;move the x pos for the next block
			CMP     R_X_POS_EN, 75			;see if we have reached the final block for the row
			BREQ 	reset_x
			BRNE	loop_blocks

reset_x :	MOV		R_X_POS_EN, 5	    ; reset to starting x pos
			ADD 	R_Y_POS, 	5		; move to next row
			CMP		R_Y_POS,  	25		;if 25, we have dwarn all of the blocks and can move on.
			BREQ    init
			BRNE	loop_blocks
;-----------------------------------------------

; Draw a smiley face, person, and square on screen
init:		;Enable object 1 (face)
			;MOV		R_X_POS_EN, 0x06
			;MOV		R_Y_POS, 	0x32
			;MOV		R_OBJ_ADDR, 0x01
			;CALL	update_obj
			;MOV		R_ARGUMENT, OBJ0_MEM	;Set up r31 with mem address
			;CALL	set_obj_data	;Store r0-2 into stack at OBJ0_MEM

			;Enable object 2 (square)
			;MOV		R_X_POS_EN, 0x01			
			;MOV		R_Y_POS, 	0x01
			;MOV		R_RGB_DATA, 0x03
			;MOV		R_OBJ_ADDR, 0x02
			;CALL	update_obj
			;MOV		R_ARGUMENT, OBJ1_MEM	;Set up r31 with mem address
			;CALL	set_obj_data	;Store r0-2 into stack at OBJ1_MEM

			;Enable object 3 (man)
			;MOV		R_X_POS_EN, 40
			;OR		R_X_POS_EN, EN_MASK
			;MOV		R_Y_POS, 	30
			;MOV		R_RGB_DATA, 0x1C
			;MOV		R_OBJ_ADDR, 0x03
			;CALL	update_obj
			;MOV		R_ARGUMENT, OBJ2_MEM	;Set up r31 with mem address
			;CALL	set_obj_data	;Store r0-2 into stack at OBJ2_MEM

			;Enable object 4 (ball)
			MOV		R_X_POS_EN, 20
			OR		R_X_POS_EN, EN_MASK
			MOV		R_Y_POS, 	50
			MOV		R_OBJ_ADDR, 0x1D
			CALL	update_obj
			MOV		R_ARGUMENT, BALL_MEM	;Set up r31 with mem address
			CALL	set_obj_data	;Store r0-2 into stack at BALL_MEM
		
		
			

main:       MOV		R_ARGUMENT, BALL_MEM  ;select to move the ball
			MOV		R_OBJ_ADDR, 0x1D
			CALL    get_obj_data	
			SEI

			
loop:		IN		r20, SWITCHES_ID 	;just to test switches 
			OUT		r20, LEDS_ID		;just to test LEDS
			BRN		loop				;hang out here waiting for keyboard interrupts

		
;------------------------------------------------------------
;- These subroutines add and/or subtract '1' from the given 
;- X or Y value, depending on the direction the object was 
;- told to go. The trick here is to not go off the screen
;- so the object is moved only if there is room to move the 
;- object without going off the screen.  
;- 
;- Tweaked Registers: possibly r0, r1 (X and Y positions)
;------------------------------------------------------------
sub_x:   CMP   R_X_POS_EN ,0x80    ; see if you can move
         BREQ  done1
         SUB   R_X_POS_EN,0x01    ; move if you can
done1:   RET

sub_y:   CMP   R_Y_POS,0x00    ; see if you can move
         BREQ  done2
         SUB   R_Y_POS,0x01    ; move if you can
done2:   RET
 
add_x:   CMP   R_X_POS_EN, MAX_X    ; see if you can move
         BREQ  done3  
         ADD   R_X_POS_EN,0x01    ; move if you can
done3:   RET

add_y:   CMP   R_Y_POS,MAX_Y    ; see if you can move
         BREQ  done4   
         ADD   R_Y_POS,0x01    ; move if you can
done4:   RET


;------------------------------------
; Subroutine get_obj_data
; Loads object data (X_POS, Y_POS, and color)
; from the stack based on address in r4
;
; R_ARGUMENT (r31) - Stack address
;------------------------------------
get_obj_data:
			LD		R_X_POS_EN, (r31)
			ADD		R_ARGUMENT, 0x01
			LD		R_Y_POS, 	(r31)
			ADD		R_ARGUMENT, 0x01
			LD		R_RGB_DATA, (r31)
			RET

;------------------------------------
; Subroutine set_obj_data
; Stores object data onto the stack based on address in r4
; Uses 3 memory words
;
; R_ARGUMENT (r31) - Stack address
;------------------------------------
set_obj_data:
			ST		R_X_POS_EN, (r31)
			ADD		R_ARGUMENT, 0x01
			ST		R_Y_POS, 	(r31)
			ADD		R_ARGUMENT, 0x01
			ST		R_RGB_DATA, (r31)
			ADD     R_ARGUMENT, 0x01  ;added so that we are already set up for the next object if consectutive (for blocks)
			RET

;------------------------------------
; Subroutine update_obj
;
; r0 - X_POS_EN
; r1 - Y_POS
; r2 - RGB_DATA
; r3 - OBJ_ADDR

;------------------------------------
update_obj:
			MOV		r4, R_OBJ_ADDR			;r4 is temp address
			OUT		r0, X_POS_EN_ID
			OUT		r1, Y_POS_ID
			OUT		r2, RGB_DATA_ID
			OUT		r4, OBJ_ADDR_ID
			MOV		r4, 0
			OUT		r4, OBJ_ADDR_ID
			RET

;------------------------------------
; Subroutine delay
; Delays the CPU by doing a long nested loop
;
;------------------------------------
delay:
					MOV		r29, OUTER_CONST
delay_outer:		MOV		r28, MIDDLE_CONST
					CMP		r29, 0x00
					BREQ	delay_done
delay_middle:		MOV		r27, INNER_CONST
					CMP		r28, 0x00
					BREQ	delay_mid_done
delay_inner:		CMP		r27, 0x00
					BREQ	delay_inner_done
					SUB		r27, 0x01	;sub inner count
					BRN		delay_inner
delay_inner_done:	SUB		r28, 0x01	;sub middle count
					BRN		delay_middle
delay_mid_done:		SUB		r29, 0x01	;sub outer count
					BRN		delay_outer
delay_done:			RET


;--------------------------------------------------------------
; Interrup Service Routine - Handles Interrupts from keyboard
;--------------------------------------------------------------
; Sample ISR that looks for various key presses. When a useful
; key press is found, the program does something useful. The 
; code also handles the key-up code and subsequent re-sending
; of the associated scan-code. 
;
; Tweaked Registers; r6, r15
;--------------------------------------------------------------
ISR:      CMP   r15, int_flag        ; check key-up flag 
          BRNE  continue
          MOV   r15, 0x00            ; clean key-up flag
          BRN   reset_ps2_register       

continue: IN    r6, PS2_KEY_CODE_ID     ; get keycode data
          OUT	r6, SSEG_ID
move_up:  CMP   r6, UP               ; decode keypress value
          BRNE  move_down 		  
          CALL  sub_y                ; verify move is possible
          CALL  update_obj             ; draw object
          BRN   reset_ps2_register

move_down:
          CMP   r6, DOWN
          BRNE  move_left 		  
          CALL  add_y                ; verify move
          CALL  update_obj             ; draw object
          BRN   reset_ps2_register

move_left:
          CMP   r6, LEFT
          BRNE  move_right 		  
          CALL  sub_x                ; verify move
          CALL  update_obj             ; draw object
          BRN   reset_ps2_register

move_right:
          CMP   r6, RIGHT
          BRNE  key_up_check		  		  
          CALL  add_x                ; verify move
          CALL  update_obj             ; draw object
          BRN   reset_ps2_register

    
key_up_check:  
          CMP   r6,KEY_UP            ; look for key-up code 
		 
          BRNE  reset_ps2_register   ; branch if not found

set_skip_flag:
          ADD   r15, 0x01            ; indicate key-up found


reset_ps2_register:                  ; reset PS2 register 
          MOV    r6, 0x01
          OUT    r6, PS2_CONTROL_ID 
          MOV    r6, 0x00
          OUT    r6, PS2_CONTROL_ID
		  RETIE
;-------------------------------------------------------------------

;---------------------------------------------------------------------
; interrupt vector 
;---------------------------------------------------------------------
.CSEG
.ORG 0x3FF
           BRN   ISR
;---------------------------------------------------------------------