
	org $2000

instrument_length	.byte $06
instrument_property	.byte $aa, $a8, $a6, $a4, $a2, $a2
instrument_envelope	.byte $38, $38, $38, $38, $38, $38

instrument_property_2	.byte $a0, $a0, $a0, $a0, $a8, $a2
instrument_envelope_2	.byte $38, $38, $38, $38, $38, $38

current_length		.byte $00
ticks			.byte $02
current_tick		.byte $00

notes			.byte $00, $13, $09, $06, $00, $13, $15, $13, $09, $19, $11, $0e, $09, $19, $1b, $19, $f9, $03, $00, $0e, $f9, $00, $03, $00, $00, $13, $00, $09, $00, $13, $15, $13
note_count		.byte $1f
current_note		.byte $00

start	lda #0
	sta 559
	ldx #0
	
loop	lda #1
	sta $d40a
	jsr routine
	jmp loop
        
routine			ldy current_length
			lda instrument_property,y
			sta $d201
			lda instrument_property_2,y
			sta $d203
			lda instrument_envelope,y
			ldy current_note
			sbc notes,y
			sta $d200
			asl
			asl
			asl
			asl
			sta $d01a
			ldy current_length
			lda instrument_envelope_2,y
			ldy current_note
			sbc notes,y
			sta $d202
			ldy current_length

routine_timer		inx

			cpx #$0
			bne end_routine

			lda current_tick

			cmp ticks
			bne next_tick

			lda #$0
			sta current_tick
			iny

			cpy instrument_length
			beq next_note
			
			sty current_length
			jmp end_routine

next_note		lda current_note
			cmp note_count
			beq reset_note
			jmp next_note_inc

reset_note		lda #$0
			sta current_note
			jmp next_note_end

next_note_inc		adc #$1
			sta current_note
next_note_end		ldy #$0
			sty current_length
			jmp end_routine

next_tick		lda current_tick
			adc #$1
			sta current_tick

end_routine		rts

	run start

