.PC02

.include "../../devices.s"

.segment "VECTORS"
.word nmi
.word reset
.word irq

.code
nmi:
irq:
  LDX #$00
  LDY #$00

reset:
  LDA #$00
  STA VIADDRA
  LDA #$FF
  STA VIADDRB
clearX:
  LDA #$00
  TAX
loopTop:
  lda string,x
  STA VIAORB
  phx
  JSR delay
  plx
  inx
  txa
  cmp #$0D
  BEQ clearX
  JMP loopTop


;delays for 0xYYXX iterations of an empty loop
delay:
  DEX
  BNE delay
  DEY
  BNE delay
  RTS

string:
  .byte "Hello World!", $0A

