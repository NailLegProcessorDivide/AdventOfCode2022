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

;;;;;;;;;;;;;;;TOP;;;;;;;;;;;;;;;;;
  LDA #$02
  STA BASE_PTR + 1
  LDA #$00
  STA BASE_PTR
  LDA #$30
  STA RES_PTR + 1
  LDA #$00
  STA RES_PTR
  
  LDY #$63 ;99
yLoopHeadTop:
  LDX #$63 ;99
  LDA #$00
  STA PREV_HIGH
xLoopHeadTop:

  STX $ff
  LDX #$00
  LDA (BASE_PTR,X)

  CMP PREV_HIGH
  BCC TopLEQ
  BEQ TopLEQ
  STA PREV_HIGH
  LDA #$01
  ORA (RES_PTR,X)
  STA (RES_PTR,X)

TopLEQ:
  CLC
  LDA #$63
  ADC BASE_PTR
  STA BASE_PTR
  LDA #$00
  ADC BASE_PTR + 1
  STA BASE_PTR + 1

  CLC
  LDA #$63
  ADC RES_PTR
  STA RES_PTR
  LDA #$00
  ADC RES_PTR + 1
  STA RES_PTR + 1
  
  LDX $ff
  DEX
  CPX #$00
  BNE xLoopHeadTop
  
  SEC
  LDA BASE_PTR
  SBC #$48
  STA BASE_PTR
  LDA BASE_PTR + 1
  SBC #$26
  STA BASE_PTR + 1

  SEC
  LDA RES_PTR
  SBC #$48
  STA RES_PTR
  LDA RES_PTR + 1
  SBC #$26
  STA RES_PTR + 1

  DEY
  CPY #$00
  BNE yLoopHeadTop

;;;;;;;;;;;;;;;RIGHT;;;;;;;;;;;;;;;;;
  LDA #$02
  STA BASE_PTR + 1
  LDA #$62
  STA BASE_PTR
  LDA #$30
  STA RES_PTR + 1
  LDA #$62
  STA RES_PTR
  
  LDY #$63 ;99
yLoopHeadRight:
  LDX #$63 ;99
  LDA #$00
  STA PREV_HIGH
xLoopHeadRight:

  STX $ff
  LDX #$00
  LDA (BASE_PTR,X)

  CMP PREV_HIGH
  BCC rightLEQ
  BEQ rightLEQ
  STA PREV_HIGH
  LDA #$01
  ORA (RES_PTR,X)
  STA (RES_PTR,X)

rightLEQ:
  SEC
  LDA BASE_PTR
  SBC #$01
  STA BASE_PTR
  LDA BASE_PTR + 1
  SBC #$00
  STA BASE_PTR + 1

  SEC
  LDA RES_PTR
  SBC #$01
  STA RES_PTR
  LDA RES_PTR + 1
  SBC #$00
  STA RES_PTR + 1
  
  LDX $ff
  DEX
  CPX #$00
  BNE xLoopHeadRight
  
  CLC
  LDA BASE_PTR
  ADC #$c6
  STA BASE_PTR
  LDA BASE_PTR + 1
  ADC #$00
  STA BASE_PTR + 1

  CLC
  LDA RES_PTR
  ADC #$c6
  STA RES_PTR
  LDA RES_PTR + 1
  ADC #$00
  STA RES_PTR + 1

  DEY
  CPY #$00
  BNE yLoopHeadRight

;;;;;;;;;;;;;;;Bot;;;;;;;;;;;;;;;;;
  LDA #$28
  STA BASE_PTR + 1
  LDA #$48
  STA BASE_PTR
  LDA #$56
  STA RES_PTR + 1
  LDA #$48
  STA RES_PTR
  
  LDY #$63 ;99
yLoopHeadBot:
  LDX #$63 ;99
  LDA #$00
  STA PREV_HIGH
xLoopHeadBot:

  STX $ff
  LDX #$00
  LDA (BASE_PTR,X)

  CMP PREV_HIGH
  BCC BotLEQ
  BEQ BotLEQ
  STA PREV_HIGH
  LDA #$01
  ORA (RES_PTR,X)
  STA (RES_PTR,X)

BotLEQ:
  SEC
  LDA BASE_PTR
  SBC #$63
  STA BASE_PTR
  LDA BASE_PTR + 1
  SBC #$00
  STA BASE_PTR + 1

  SEC
  LDA RES_PTR
  SBC #$63
  STA RES_PTR
  LDA RES_PTR + 1
  SBC #$00
  STA RES_PTR + 1
  
  LDX $ff
  DEX
  CPX #$00
  BNE xLoopHeadBot
  
  CLC
  LDA BASE_PTR
  ADC #$48
  STA BASE_PTR
  LDA BASE_PTR + 1
  ADC #$26
  STA BASE_PTR + 1

  CLC
  LDA RES_PTR
  ADC #$48
  STA RES_PTR
  LDA RES_PTR + 1
  ADC #$26
  STA RES_PTR + 1

  DEY
  CPY #$00
  BNE yLoopHeadBot

;;;;;;;;;;;;;;;LEFT;;;;;;;;;;;;;;;;;
  LDA #$02
  STA BASE_PTR + 1
  LDA #$00
  STA BASE_PTR
  LDA #$30
  STA RES_PTR + 1
  LDA #$00
  STA RES_PTR
  
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


