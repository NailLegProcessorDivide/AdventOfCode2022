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
head:
  LDA VIAORB
  CMP #$41
  BNE noKill
  JMP end
noKill:
  SEC
  SBC #$30
  STA $04
  LDA VIAORB
  CMP #$2D
  BEQ single1
  SEC
  SBC #$30
  JSR mul10
  STA $04
  LDA VIAORB
single1:
  LDA $04
  STA $08

  LDA VIAORB
  SEC
  SBC #$30
  STA $04
  LDA VIAORB
  CMP #$2C
  BEQ single2
  SEC
  SBC #$30
  JSR mul10
  STA $04
  LDA VIAORB
single2:
  LDA $04
  STA $09

  LDA VIAORB
  SEC
  SBC #$30
  STA $04
  LDA VIAORB
  CMP #$2D
  BEQ single3
  SEC
  SBC #$30
  JSR mul10
  STA $04
  LDA VIAORB
single3:
  LDA $04
  STA $0A

  LDA VIAORB
  SEC
  SBC #$30
  STA $04
  LDA VIAORB
  CMP #$0A
  BEQ single4
  SEC
  SBC #$30
  JSR mul10
  STA $04
  LDA VIAORB
single4:
  LDA $04
  STA $0B

  LDA $09
  CMP $0a
  BCC skip
  LDA $0B
  CMP $08
  BCC skip

ink:
  CLC
  LDA #$01
  ADC $00
  STA $00
  LDA #$0
  ADC $01
  STA $01

skip:
  JMP head


  
end:
  LDA $0
  STA VIAORB
  LDA $1
  STA VIAORB
  JMP die

mul10:
  LDX #$10
mulLoop:
  DEX
  CLC
  ADC $04
  CPX #$00
  BNE mulLoop
  RTS

die:
  JMP die


