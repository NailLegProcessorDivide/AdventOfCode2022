.PC02

.include "../../devices.s"
.include "macrotools.s"

.segment "VECTORS"
.word nmi
.word reset
.word irq

.define PAIN $00
.define BEST_SCORE $00
.define CURRENT $20
.define CURRENT2 $30
.define BASE_PTR $0c
.define WORK_PTR $0e
.define NEW_SCORE $10

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

  inc_16 BASE_PTR
  
  DEX
  CPX #$00
  BNE xLoopHead

  LDA VIAORB
  DEY
  CPY #$00
  BNE yLoopHead

;;;;;;;;;;;;StartWork;;;;;;;;;;;;

  LDA #$02
  STA BASE_PTR + 1
  LDA #$00
  STA BASE_PTR
  
  LDY #$63 ;99
yLoopHeadMain:
  LDX #$63 ;99
xLoopHeadMain:

  STX $ff
  STY $fe
  LDX #$00
  LDA (BASE_PTR, X)
  STA $fd

  LDY $ff
  cp_16 WORK_PTR, BASE_PTR
leftHead:
  CPY #$01
  BEQ leftTail
  DEY
  add_16_8 WORK_PTR, #$01
  LDA (WORK_PTR, X)
  CMP $fd
  BCS leftTail
  JMP leftHead
leftTail:
  LDA $ff
  STY $fc
  SEC
  SBC $fc
  STA VIAORB
  STA CURRENT
  LDA #$00
  STA CURRENT+1
  STA CURRENT+2

  LDY $fe
  cp_16 WORK_PTR, BASE_PTR
upHead:
  CPY #$01
  BEQ upTail
  DEY
  add_16_8 WORK_PTR, #$63
  LDA (WORK_PTR, X)
  CMP $fd
  BCS upTail
  JMP upHead
upTail:
  LDA $fe
  STY $fc
  SEC
  SBC $fc
  STA $fc
  STA VIAORB
  mul_24_8 CURRENT2, CURRENT, $fc

  LDY $ff
  cp_16 WORK_PTR, BASE_PTR
rightHead:
  CPY #$63
  BEQ rightTail
  INY
  sub_16_8 WORK_PTR, #$01
  LDA (WORK_PTR, X)
  CMP $fd
  BCS rightTail
  JMP rightHead
rightTail:
  TYA
  SEC
  SBC $ff
  STA $fc
  STA VIAORB
  mul_24_8 CURRENT, CURRENT2, $fc

  LDY $fe
  cp_16 WORK_PTR, BASE_PTR
downHead:
  CPY #$63
  BEQ downTail
  INY
  sub_16_8 WORK_PTR, #$63
  LDA (WORK_PTR, X)
  CMP $fd
  BCS downTail
  JMP downHead
downTail:
  TYA
  SEC
  SBC $fe
  STA $fc
  STA VIAORB
  mul_24_8 CURRENT2, CURRENT, $fc

  leq_24 BEST_SCORE, CURRENT2, noNewBest
  LDA CURRENT2
  STA BEST_SCORE
  LDA CURRENT2 + 1
  STA BEST_SCORE + 1
  LDA CURRENT2 + 2
  STA BEST_SCORE + 2
noNewBest:
  LDA CURRENT2 + 2
  STA VIAORB
  LDA CURRENT2 + 1
  STA VIAORB
  LDA CURRENT2
  STA VIAORB
  LDA $ff
  STA VIAORB
  LDA $fe
  STA VIAORB
  LDA #$00
  STA VIAORB

  inc_16 BASE_PTR
  
  LDX $ff
  LDY $fe
  DEX         ;end inner loop
  BNE xLoopHeadMainWarp

  DEY
  BNE yLoopHeadMainWarp
  JMP end

xLoopHeadMainWarp:
  JMP xLoopHeadMain
yLoopHeadMainWarp:
  JMP yLoopHeadMain

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
  LDA BEST_SCORE + 2
  STA VIAORB
  LDA BEST_SCORE + 1
  STA VIAORB
  LDA BEST_SCORE
  STA VIAORB
  
  JMP die

die:
  JMP die


