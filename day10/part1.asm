.PC02

.include "../../devices.s"
.include "macrotools.s"

.segment "VECTORS"
.word nmi
.word reset
.word irq

.define TOTAL $00
.define X_VAL $04
.define TIME $08
.define TIME2 $09
.define WORK24 $0a
.define ATOI_LOW $0d
.define ATOI_HIGH $0e
.define SIGN $0f


.code
nmi:
irq:
reset:
  LDA #$01
  STA X_VAL
  STA TIME

lineHead:
  LDA VIAORB
  LDA VIAORB
  LDA VIAORB
  LDA VIAORB
  STA VIAORB
  CMP #'x'
  BEQ handleAdd
  CMP #$ff
  BEQ goEnd
  JSR stepTime
  LDA #$0a
  JSR consumeUntilA
  jmp lineHead

goEnd:
  JMP end

handleAdd:
  JSR stepTime
  JSR stepTime
  LDA VIAORB
  LDA VIAORB
  STA SIGN
  CMP #'-'
  BNE neg
  LDA VIAORB
neg:
  SEC
  SBC #$30
  STA ATOI_LOW
  LDA VIAORB
  CMP #$0a
  BNE nextChar
  JMP noNextChar
nextChar:
  SEC
  SBC #$30
  STA ATOI_HIGH
  LDA VIAORB
  LDA ATOI_LOW
  CLC
  ADC ATOI_LOW
  CLC
  ADC ATOI_LOW
  CLC
  ADC ATOI_LOW
  CLC
  ADC ATOI_LOW
  CLC
  ADC ATOI_LOW
  CLC
  ADC ATOI_LOW
  CLC
  ADC ATOI_LOW
  CLC
  ADC ATOI_LOW
  CLC
  ADC ATOI_LOW
  CLC
  ADC ATOI_HIGH
  STA ATOI_LOW

noNextChar:
  LDA ATOI_LOW
  LDA SIGN
  CMP #'-'
  BNE dontFlip
  sub_24_8 X_VAL, ATOI_LOW
  jmp lineHead

dontFlip:
  add_24_8 X_VAL, ATOI_LOW
  JMP lineHead


stepTime:
  inc TIME
  LDA TIME
  STA TIME2
  CMP #20
  BEQ update
  CMP #60
  BEQ update
  CMP #100
  BEQ update
  CMP #140
  BEQ update
  CMP #180
  BEQ update
  CMP #220
  BEQ update
  JMP dontUpdate
update:
  LDA X_VAL + 2
  STA VIAORB
  LDA X_VAL + 1
  STA VIAORB
  LDA X_VAL + 0
  STA VIAORB
  LDA TIME
  STA VIAORB
  mul_24_8 WORK24, X_VAL, TIME2
  add_24_24 TOTAL, WORK24
dontUpdate:
  RTS

consumeUntilA:
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
  
  JMP die

die:
  JMP die


