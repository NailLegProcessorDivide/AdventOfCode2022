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

  LDX #$0
loopTop:
  LDA VIAORB ;op
  CMP #$0A
  BEQ process
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
  STA $10, X
  INX
  JMP loopTop
process:
  TXA
  LSR A
  STA $04
  LDA #$00

  LDX #$35 ;52 chars
clearHead:
  STA $200, X
  DEX
  CPX #$00
  BNE clearHead

  LDY $04
  LDA #$01
firstPouch:
  DEY
  LDX $10, Y
  STA $200, X
  CPY #$00
  BNE firstPouch

  LDY $04
secondPouch:
  LDX $10, Y
  LDA $200, X
  INY
  CMP #$01
  BNE secondPouch

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

  LDX #$00
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


