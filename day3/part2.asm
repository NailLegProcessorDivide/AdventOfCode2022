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
  LDY #$4
  LDX #$35 ;52 chars
  LDA #$00
clearHead:
  STA $200, X
  DEX
  CPX #$00
  BNE clearHead

lineLoad:
  LDA VIAORB ;op
  CMP #$0A
  BNE newLine
  TYA
  LSR A
  TAY
  LDA VIAORB
newLine:
  CMP #$20
  BEQ end
  EOR #$20
  CMP #$61
  BCC linearise
  SEC
  SBC #$6
linearise:
  SEC
  SBC #$40
  TAX
  TYA
  CLC
  ORA $200, X
  STA $200, X
  CMP #$07
  BEQ addScore
  JMP lineLoad

addScore:
  TXA
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

endl:
  LDA VIAORB ;op
  CMP #$0A
  BNE endl

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
