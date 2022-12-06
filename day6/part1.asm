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
  LDX #$00
  STX $00
  STX $01

  LDA VIAORB
  STA $4
  LDA VIAORB
  STA $5
  LDA VIAORB
  STA $6
loopHead:
  LDA VIAORB
  STA $7
  JSR tdif

  LDA VIAORB
  STA $4
  JSR tdif

  LDA VIAORB
  STA $5
  JSR tdif

  LDA VIAORB
  STA $6
  JSR tdif
  JMP loopHead

tdif:
  LDA #$01
  CLC
  ADC $00
  STA $00
  LDA #$00
  ADC $01
  STA $01
  LDX #$00

  LDA $04
  CMP $05
  BEQ tdifRet
  CMP $06
  BEQ tdifRet
  CMP $07
  BEQ tdifRet

  LDA $05
  CMP $06
  BEQ tdifRet
  CMP $07
  BEQ tdifRet

  LDA $06
  CMP $07
  BEQ tdifRet
  
  JMP end

tdifRet:
  RTS

end:
  LDA $00
  STA VIAORB
  LDA $01
  STA VIAORB
  
  JMP die

die:
  JMP die


