.PC02

.include "../../devices.s"

.segment "VECTORS"
.word nmi
.word reset
.word irq

.define stack0height $10
.define stack1height $11
.define stack2height $12
.define stack3height $13
.define stack4height $14
.define stack5height $15
.define stack6height $16
.define stack7height $17
.define stack8height $18

.define stack0base   $200
.define stack1base   $300
.define stack2base   $400
.define stack3base   $500
.define stack4base   $600
.define stack5base   $700
.define stack6base   $800
.define stack7base   $900
.define stack8base   $a00

.code
nmi:
irq:
reset:
  LDX #$00
  STX $00
  STX $02
box0:
  LDA VIAORB
  CMP #$0A
  BEQ box0end
  STA stack0base,X
  INX
  JMP box0

box0end:
  STX stack0height
  LDX #$00
box1:
  LDA VIAORB
  CMP #$0A
  BEQ box1end
  STA stack1base,X
  INX
  JMP box1

box1end:
  STX stack1height
  LDX #$00
box2:
  LDA VIAORB
  CMP #$0A
  BEQ box2end
  STA stack2base,X
  INX
  JMP box2

box2end:
  STX stack2height
  LDX #$00
box3:
  LDA VIAORB
  CMP #$0A
  BEQ box3end
  STA stack3base,X
  INX
  JMP box3

box3end:
  STX stack3height
  LDX #$00
box4:
  LDA VIAORB
  CMP #$0A
  BEQ box4end
  STA stack4base,X
  INX
  JMP box4

box4end:
  STX stack4height
  LDX #$00
box5:
  LDA VIAORB
  CMP #$0A
  BEQ box5end
  STA stack5base,X
  INX
  JMP box5

box5end:
  STX stack5height
  LDX #$00
box6:
  LDA VIAORB
  CMP #$0A
  BEQ box6end
  STA stack6base,X
  INX
  JMP box6

box6end:
  STX stack6height
  LDX #$00
box7:
  LDA VIAORB
  CMP #$0A
  BEQ box7end
  STA stack7base,X
  INX
  JMP box7

box7end:
  STX stack7height
  LDX #$00
box8:
  LDA VIAORB
  CMP #$0A
  BEQ box8end
  STA stack8base,X
  INX
  JMP box8

box8end:
  STX stack8height

lineTop:
  LDX VIAORB
  CPX #$41
  BNE cont
  JMP end
cont:
  LDX VIAORB
  LDX VIAORB
  LDX VIAORB
  LDX VIAORB

  LDA VIAORB
  SEC
  SBC #$30
  STA $04
  LDA VIAORB
  CMP #$20
  BEQ single
  SEC
  SBC #$30
  JSR mul10
  STA $04      ;count
  LDX VIAORB
single:
  LDA $4
  STA $7
  LDX VIAORB
  LDX VIAORB
  LDX VIAORB
  LDX VIAORB
  LDX VIAORB

  LDA VIAORB
  SEC
  SBC #$31
  STA $05       ;from

  LDX VIAORB
  LDX VIAORB
  LDX VIAORB
  LDX VIAORB

  LDA VIAORB
  LDX VIAORB
  SEC
  SBC #$31
  STA $06       ;to

  LDX $5
  LDA stack0height, X
  STA $8
  SEC
  SBC $4
  STA stack0height, X
  INX
  INX
  STX $01

  LDX $6
  LDA stack0height, X
  CLC
  ADC $4
  STA stack0height, X
  STA $9
  INX
  INX
  STX $03

ittrHead:
  DEC $8
  DEC $9

  LDY $8
  LDA ($00), Y
  LDY $9
  STA ($02), Y
  DEC $4
  LDA $4
  CMP #$0
  BNE ittrHead
  JMP lineTop

end:
  LDX stack0height
  DEX
  LDA stack0base, X
  STA VIAORB
  
  LDX stack1height
  DEX
  LDA stack1base, X
  STA VIAORB
  
  LDX stack2height
  DEX
  LDA stack2base, X
  STA VIAORB
  
  LDX stack3height
  DEX
  LDA stack3base, X
  STA VIAORB
  
  LDX stack4height
  DEX
  LDA stack4base, X
  STA VIAORB
  
  LDX stack5height
  DEX
  LDA stack5base, X
  STA VIAORB
  
  LDX stack6height
  DEX
  LDA stack6base, X
  STA VIAORB
  
  LDX stack7height
  DEX
  LDA stack7base, X
  STA VIAORB
  
  LDX stack8height
  DEX
  LDA stack8base, X
  STA VIAORB
  
  JMP die

mul10:
  LDX #$0a
mulLoop:
  DEX
  CLC
  ADC $04
  CPX #$00
  BNE mulLoop
  RTS

mul26:
  LDX #$1a
mul26Loop:
  DEX
  CLC
  ADC $07
  CPX #$00
  BNE mul26Loop
  RTS

die:
  JMP die


