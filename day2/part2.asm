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
  LDA #$0
;total
  STA $00
  STA $01
  STA $02
  STA $03
loopTop:
  LDA VIAORB;op
  SEC
  SBC #$40
  CMP #$4
  BNE cont4
  JMP end
cont4:
  LDX VIAORB;space
  LDX VIAORB;me

  STA $04
  TXA
  SEC
  SBC #$58 ;'W'
  TAX
  LDA $04

  CMP #$1
  BEQ cont1
  JMP comp2
cont1:
  LDA rock, X
  JMP selEnd
comp2:
  CMP #$2
  BEQ cont2
  JMP comp3
cont2:
  LDA paper, X
  JMP selEnd
comp3:
  CMP #$3
  BEQ cont3
  JMP selEnd
cont3:
  LDA scisors, X
selEnd:
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
  JMP loopTop
  
 
end:
  LDA $0
  STA VIAORB
  LDA $1
  STA VIAORB
  LDA $2
  STA VIAORB
  LDA $3
  STA VIAORB
  JMP die


die:
  JMP die

;[y, m]
rock:
  .byte 3, 4, 8
paper:
  .byte 1, 5, 9
scisors:
  .byte 2, 6, 7
points:
  .byte 2, 6, 7

