.PC02

.include "../../devices.s"

.segment "VECTORS"
.word nmi
.word reset
.word irq

.code
nmi:
irq:
reset:
  LDA #$00
;current
  STA $00
  STA $01
  STA $02
  STA $03
;max1
  STA $04
  STA $05
  STA $06
  STA $07
;max2
  STA $14
  STA $15
  STA $16
  STA $17
;max3
  STA $18
  STA $19
  STA $1a
  STA $1b
;elf
  STA $0C
  STA $0D
  STA $0E
  STA $0F

  LDA VIAORB 

doNextItem:
  CLC
  LDA $00
  ADC $0C
  STA $0C
  LDA $01
  ADC $0D
  STA $0D
  LDA $02
  ADC $0E
  STA $0E
  LDA $03
  ADC $0F
  STA $0F

  LDX #$00
  STX $00
  STX $01
  STX $02
  STX $03
  LDA VIAORB
  STA $11
  CMP #$0A
  BEQ doNextElf
  JMP doNextChar

doNextElf:
  LDA $07    ;new
  CMP $0f    ;new < old
  BCC newMax1
  BNE skipMax1
  LDA $06
  CMP $0e
  BCC newMax1
  BNE skipMax1
  LDA $05
  CMP $0d
  BCC newMax1
  BNE skipMax1
  LDA $04
  CMP $0c
  BCC newMax1
  JMP skipMax1
newMax1:
  LDA $14
  STA $18
  LDA $15
  STA $19
  LDA $16
  STA $1a
  LDA $17
  STA $1b

  LDA $04
  STA $14
  LDA $05
  STA $15
  LDA $06
  STA $16
  LDA $07
  STA $17

  LDA $0C
  STA $04
  LDA $0D
  STA $05
  LDA $0E
  STA $06
  LDA $0F
  STA $07
  JMP skipMax3

skipMax1:
  LDA $17    ;new
  CMP $0f    ;new < old
  BCC newMax2
  BNE skipMax2
  LDA $16
  CMP $0e
  BCC newMax2
  BNE skipMax2
  LDA $15
  CMP $0d
  BCC newMax2
  BNE skipMax2
  LDA $14
  CMP $0c
  BCC newMax2
  JMP skipMax2
newMax2:
  LDA $14
  STA $18
  LDA $15
  STA $19
  LDA $16
  STA $1a
  LDA $17
  STA $1b

  LDA $0C
  STA $14
  LDA $0D
  STA $15
  LDA $0E
  STA $16
  LDA $0F
  STA $17
  JMP skipMax3

skipMax2:
  LDA $1b    ;new
  CMP $0f    ;new < old
  BCC newMax3
  BNE skipMax3
  LDA $1a
  CMP $0e
  BCC newMax3
  BNE skipMax3
  LDA $19
  CMP $0d
  BCC newMax3
  BNE skipMax3
  LDA $18
  CMP $0c
  BCC newMax3
  JMP skipMax3
newMax3:
  LDA $0C
  STA $18
  LDA $0D
  STA $19
  LDA $0E
  STA $1a
  LDA $0F
  STA $1b

skipMax3:
  LDA #$00
  STA $0C
  STA $0D
  STA $0E
  STA $0F
  LDA VIAORB
  STA $11

doNextChar:
  JSR mul10
  LDA $11
  SBC #$30
  CLC
  ADC $00
  STA $00
  LDA #$00
  ADC $01
  STA $01
  LDA #$00
  ADC $02
  STA $02
  LDA #$00
  ADC $03
  STA $03
  LDA VIAORB
  STA $11
  CMP #$A
  BEQ nextItemWarp
  CMP #$41
  BEQ end
  JMP doNextChar

nextItemWarp:
  jmp doNextItem
 
end:
  LDA $7
  STA VIAORB
  LDA $6
  STA VIAORB
  LDA $5
  STA VIAORB
  LDA $4
  STA VIAORB
  LDA $17
  STA VIAORB
  LDA $16
  STA VIAORB
  LDA $15
  STA VIAORB
  LDA $14
  STA VIAORB
  LDA $1b
  STA VIAORB
  LDA $1a
  STA VIAORB
  LDA $19
  STA VIAORB
  LDA $18
  STA VIAORB
  JMP die
    
mul10:
  LDA $00
  STA $08
  LDA $01
  STA $09
  LDA $02
  STA $0A
  LDA $03
  STA $0B
  LDX #$09
mulLoop:
  DEX
  CLC
  LDA $08
  ADC $00
  STA $00
  LDA $09
  ADC $01
  STA $01
  LDA $0A
  ADC $02
  STA $02
  LDA $0B
  ADC $03
  STA $03
  CPX #$00
  BNE mulLoop
  RTS


die:
  JMP die

string:
  .byte "0123456789ABCDEF"

