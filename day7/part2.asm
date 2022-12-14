.PC02

.include "../../devices.s"

.segment "VECTORS"
.word nmi
.word reset
.word irq

.define TOTAL $00
.define STACK_BASE $0c
.define StackHead $FE

.code
nmi:
irq:
reset:
  LDA #$7f
  STA $00
  STA $01
  STA $02
  STA $03

ittrClear:
  LDA #$0a
  JSR consumeUntilA

ittrHead:
  LDA VIAORB
  CMP #$41
  BNE hop
  JMP end
hop:
  CMP #$64
  BEQ ittrClear
  checkCD:
  CMP #$24
  BEQ cmd
  JSR read10

  CLC
  LDA STACK_BASE, X
  ADC $04
  STA STACK_BASE, X
  LDA STACK_BASE + 1, X
  ADC $05
  STA STACK_BASE + 1, X
  LDA STACK_BASE + 2, X
  ADC $06
  STA STACK_BASE + 2, X
  LDA STACK_BASE + 3, X
  ADC $07
  STA STACK_BASE + 3, X
  JMP ittrClear

cmd:
  LDA VIAORB
  LDA VIAORB
  CMP #$63
  BEQ cd
  JMP ittrClear

cd:
  LDA VIAORB
  LDA VIAORB
  LDA VIAORB
  CMP #$2e
  BEQ cdUp

cdNorm:

  INX
  INX
  INX
  INX
  LDA #$00
  STA STACK_BASE, X
  STA STACK_BASE + 1, X
  STA STACK_BASE + 2, X
  STA STACK_BASE + 3, X
  JMP ittrClear

cdUp: ;100 000 = 0x1 86 a0

  LDA $03
  CMP STACK_BASE + 3, X
  bcc raiseStack
  BEQ check21
  JMP jmpPass10
check21:
  LDA $02
  CMP STACK_BASE + 2, X
  bcc raiseStack
  BEQ check11
  JMP jmpPass10
check11:
  LDA $01
  CMP STACK_BASE + 1, X
  bcc raiseStack
  BEQ check01
  JMP jmpPass10
check01:
  LDA $00
  CMP STACK_BASE, X
  bcc raiseStack

jmpPass10:
  LDA #$00
  CMP STACK_BASE + 3, X
  BEQ check61
  BCS raiseStack
  JMP jmpPass1
check61:
  LDA #$7a
  CMP STACK_BASE + 2, X
  BEQ check51
  BCS raiseStack
  JMP jmpPass1
check51:
  LDA #$bf
  CMP STACK_BASE + 1, X
  BEQ check41
  BCS raiseStack
  JMP jmpPass1
check41:
  LDA #$d6
  CMP STACK_BASE, X
  BEQ jmpPass1
  BCS raiseStack

jmpPass1:


  CLC
  LDA STACK_BASE, X
  STA $00
  LDA STACK_BASE + 1, X
  STA $01
  LDA STACK_BASE + 2, X
  STA $02
  LDA STACK_BASE + 3, X
  STA $03
  
raiseStack:
  
  CLC
  LDA STACK_BASE, X
  ADC STACK_BASE - 4, X
  STA STACK_BASE - 4, X
  LDA STACK_BASE + 1, X
  ADC STACK_BASE - 3, X
  STA STACK_BASE - 3, X
  LDA STACK_BASE + 2, X
  ADC STACK_BASE - 2, X
  STA STACK_BASE - 2, X
  LDA STACK_BASE + 3, X
  ADC STACK_BASE - 1, X
  STA STACK_BASE - 1, X

  DEX
  DEX
  DEX
  DEX
  JMP ittrClear

read10:
  STA $ff
  LDA #$00
  STA $04
  STA $05
  STA $06
  STA $07

read10LoopHead:
  JSR mul10
  LDA $ff
  SEC
  SBC #$30
  CLC
  ADC $04
  STA $04
  LDA #$00
  ADC $05
  STA $05
  LDA #$00
  ADC $06
  STA $06
  LDA #$00
  ADC $07
  STA $07

  LDA VIAORB
  STA $ff
  CMP #$20
  BNE read10LoopHead
  RTS
    
mul10:
  LDA $04
  STA $08
  LDA $05
  STA $09
  LDA $06
  STA $0A
  LDA $07
  STA $0B
  LDY #$09
mulLoop:
  DEY
  CLC
  LDA $08
  ADC $04
  STA $04
  LDA $09
  ADC $05
  STA $05
  LDA $0A
  ADC $06
  STA $06
  LDA $0B
  ADC $07
  STA $07
  CPY #$00
  BNE mulLoop
  RTS

consumeUntilA:
  CMP VIAORB
  BNE consumeUntilA
  RTS

strcpy:
  CMP VIAORB
  BNE consumeUntilA
  RTS

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

  CPX #$00
  BEQ ender

  LDA $03
  CMP STACK_BASE + 3, X
  bcc raiseStackE
  BEQ check22
  JMP jmpPass20
check22:
  LDA $02
  CMP STACK_BASE + 2, X
  bcc raiseStackE
  BEQ check12
  JMP jmpPass20
check12:
  LDA $01
  CMP STACK_BASE + 1, X
  bcc raiseStackE
  BEQ check02
  JMP jmpPass20
check02:
  LDA $00
  CMP STACK_BASE, X
  bcc raiseStackE

jmpPass20:
  LDA STACK_BASE + 3, X
  CMP #$00
  bcc raiseStackE
  BEQ check62
  JMP jmpPass2
check62:
  LDA STACK_BASE + 2, X
  CMP #$7a
  bcc raiseStackE
  BEQ check52
  JMP jmpPass2
check52:
  LDA STACK_BASE + 1, X
  CMP #$bf
  bcc raiseStackE
  BEQ check42
  JMP jmpPass2
check42:
  LDA STACK_BASE, X
  CMP #$d6
  bcc raiseStackE

jmpPass2:
  LDA STACK_BASE, X
  STA $00
  LDA STACK_BASE + 1, X
  STA $01
  LDA STACK_BASE + 2, X
  STA $02
  LDA STACK_BASE + 3, X
  STA $03
  
raiseStackE:
  CLC
  LDA STACK_BASE, X
  ADC STACK_BASE - 4, X
  STA STACK_BASE - 4, X
  LDA STACK_BASE + 1, X
  ADC STACK_BASE - 3, X
  STA STACK_BASE - 3, X
  LDA STACK_BASE + 2, X
  ADC STACK_BASE - 2, X
  STA STACK_BASE - 2, X
  LDA STACK_BASE + 3, X
  ADC STACK_BASE - 1, X
  STA STACK_BASE - 1, X

  DEX
  DEX
  DEX
  DEX
  jmp end
ender:
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


