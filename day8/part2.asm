.PC02

.include "../../devices.s"

.segment "VECTORS"
.word nmi
.word reset
.word irq

.define TOTAL $00
.define BASE_PTR $02
.define RES_PTR $04
.define PREV_HIGH $06
.define MUL_X $08
.define MUL_A $0C
.define MUL_A $10

.code
nmi:
irq:
reset:
  LDA #$00
  STA $00
  STA $01
  LDA #$02
  STA BASE_PTR + 1
  LDA #$00
  STA BASE_PTR

  LDY #$63 ;99
yLoopHead:
  LDX #$63 ;99
xLoopHead:
  LDA VIAORB
  SEC
  SBC #$2f

  STX $ff
  LDX #$00
  STA (BASE_PTR,X)
  LDX $ff

  CLC
  LDA #$01
  ADC $02
  STA $02
  LDA #$00
  ADC $03
  STA $03
  
  DEX
  CPX #$00
  BNE xLoopHead

  LDA VIAORB
  DEY
  CPY #$00
  BNE yLoopHead


  LDA #$02
  STA BASE_PTR + 1
  LDA #$00
  STA BASE_PTR
  
  LDY #$63 ;99
yLoopHeadLeft:
  LDX #$63 ;99
  LDA #$00
  STA PREV_HIGH
xLoopHeadLeft:

  STX $ff
  LDX #$00
  LDA (BASE_PTR,X)

  CMP PREV_HIGH
  BCC leftLEQ
  BEQ leftLEQ
  STA PREV_HIGH
  LDA #$01
  ORA (RES_PTR,X)
  STA (RES_PTR,X)

leftLEQ:
  LDA (RES_PTR,X)
  STA VIAORB
  CLC
  ADC $00
  STA $00
  LDA #$00
  ADC $01
  STA $01
  
  CLC
  LDA #$01
  ADC BASE_PTR
  STA BASE_PTR
  LDA #$00
  ADC BASE_PTR + 1
  STA BASE_PTR + 1

  CLC
  LDA #$01
  ADC RES_PTR
  STA RES_PTR
  LDA #$00
  ADC RES_PTR + 1
  STA RES_PTR + 1
  
  LDX $ff
  DEX
  CPX #$00
  BNE xLoopHeadLeft

  LDA #$0A
  STA VIAORB

  DEY
  CPY #$00
  BNE yLoopHeadLeft

notNextLine:
  SEC
  SBC #$30
  JMP end

read10:
  STA $ff
  LDA #$00
  STA $04
  STA $05
  STA $06
  STA $07

end:
  LDA $03
  STA VIAORB
  LDA $02
  STA VIAORB
  LDA $01
  STA VIAORB
  LDA $00
  STA VIAORB
  TXA
  STA VIAORB
  
  JMP die

die:
  JMP die


