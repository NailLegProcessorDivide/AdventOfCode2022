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
  LDX #$0D
  STX $00
  LDX #$00
  STX $01

  LDA VIAORB
  STA $4
  LDA VIAORB
  STA $5
  LDA VIAORB
  STA $6
  LDA VIAORB
  STA $7
  LDA VIAORB
  STA $8
  LDA VIAORB
  STA $9
  LDA VIAORB
  STA $a
  LDA VIAORB
  STA $b
  LDA VIAORB
  STA $c
  LDA VIAORB
  STA $d
  LDA VIAORB
  STA $e
  LDA VIAORB
  STA $f
  LDA VIAORB
  STA $10
loopHead:
  LDA VIAORB
  STA $11
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
  
  LDA VIAORB
  STA $7
  JSR tdif
  
  LDA VIAORB
  STA $8
  JSR tdif
  
  LDA VIAORB
  STA $9
  JSR tdif
  
  LDA VIAORB
  STA $a
  JSR tdif
  
  LDA VIAORB
  STA $b
  JSR tdif
  
  LDA VIAORB
  STA $c
  JSR tdif
  
  LDA VIAORB
  STA $d
  JSR tdif
  
  LDA VIAORB
  STA $e
  JSR tdif
  
  LDA VIAORB
  STA $f
  JSR tdif
  
  LDA VIAORB
  STA $10
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
  LDY #$01

xloop:

yloop:

  LDA $04, X
  CMP $04, Y
  BEQ tdifRet
  INY
  CPY #$0E
  BNE yloop
  INX
  TXA
  TAY
  INY
  CPX #$0D
  BNE xloop
  
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


