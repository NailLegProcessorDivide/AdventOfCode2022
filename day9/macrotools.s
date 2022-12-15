
.macro zero_8 dst
  LDA #$00
  STA dst
.endmacro

.macro zero_16 dst
  zero_8 dst
  STA dst+1
.endmacro

.macro zero_24 dst
  zero_16 dst
  STA dst+2
.endmacro

.macro lsl_16 src
  .local end
  .local shiftInc
  ASL src
  BCS shiftInc
  ASL src+1
  JMP end
shiftInc:
  ASL src+1
  PHP
  INC src+1
  PLP
end:
.endmacro

.macro cp_16 dst, src
  LDA src
  STA dst
  LDA src+1
  STA dst+1
.endmacro

.macro cp_24 dst, src
  LDA src
  STA dst
  LDA src+1
  STA dst+1
  LDA src+2
  STA dst+2
.endmacro

.macro inc_16 src
  CLC
  LDA #$01
  ADC src
  STA src
  LDA #$00
  ADC src + 1
  STA src + 1
.endmacro

.macro add_8_8 dst, src
  CLC
  LDA dst
  ADC src
  STA dst
.endmacro

.macro add_16_8 dst, src
  CLC
  LDA dst
  ADC src
  STA dst
  LDA dst + 1
  ADC #$00
  STA dst + 1
.endmacro

.macro add_16_16 dst, src
  add_8_8 dst, src
  LDA dst + 1
  ADC src + 1
  STA dst + 1
.endmacro

.macro add_24_24 dst, src
  add_16_16 dst, src
  LDA dst + 2
  ADC src + 2
  STA dst + 2
.endmacro

.macro add_32_32 dst, src
  add_24_24 dst, src
  LDA dst + 3
  ADC src + 3
  STA dst + 3
.endmacro

.macro sub_8_8 dst, src
  SEC
  LDA dst
  SBC src
  STA dst
.endmacro

.macro sub_16_8 dst, src
  SEC
  LDA dst
  SBC src
  STA dst
  LDA dst + 1
  SBC #$00
  STA dst + 1
.endmacro

.macro sub_16_16 dst, src
  add_8_8 dst, src
  LDA dst + 1
  SBC src + 1
  STA dst + 1
.endmacro

.macro sub_24_24 dst, src
  add_16_16 dst, src
  LDA dst + 2
  SBC src + 2
  STA dst + 2
.endmacro

.macro sub_32_32 dst, src
  add_24_24 dst, src
  LDA dst + 3
  SBC src + 3
  STA dst + 3
.endmacro

.macro mul_24_8 dst, src1, src2
  .local skip8
  .local skip7
  .local skip6
  .local skip5
  .local skip4
  .local skip3
  .local skip2
  .local skip1
  LDA #$00
  STA dst+2
  STA dst+1
  sta dst

  ASL src2
  BCC skip8
  add_24_24 dst, src1
skip8:
  add_24_24 dst, dst

  ASL src2
  BCC skip7
  add_24_24 dst, src1
skip7:
  add_24_24 dst, dst

  ASL src2
  BCC skip6
  add_24_24 dst, src1
skip6:
  add_24_24 dst, dst

  ASL src2
  BCC skip5
  add_24_24 dst, src1
skip5:
  add_24_24 dst, dst

  ASL src2
  BCC skip4
  add_24_24 dst, src1
skip4:
  add_24_24 dst, dst

  ASL src2
  BCC skip3
  add_24_24 dst, src1
skip3:
  add_24_24 dst, dst

  ASL src2
  BCC skip2
  add_24_24 dst, src1
skip2:
  add_24_24 dst, dst

  ASL src2
  BCC skip1
  add_24_24 dst, src1
skip1:
.endmacro

.macro mul_8_8 dst, src1, src2
  .local skip8
  .local skip7
  .local skip6
  .local skip5
  .local skip4
  .local skip3
  .local skip2
  .local skip1
  LDA #$00
  STA dst+2
  STA dst+1
  sta dst

  ASL src2
  BCC skip8
  add_8_8 dst, src1
skip8:
  add_8_8 dst, dst

  ASL src2
  BCC skip7
  add_8_8 dst, src1
skip7:
  add_8_8 dst, dst

  ASL src2
  BCC skip6
  add_8_8 dst, src1
skip6:
  add_8_8 dst, dst

  ASL src2
  BCC skip5
  add_8_8 dst, src1
skip5:
  add_8_8 dst, dst

  ASL src2
  BCC skip4
  add_8_8 dst, src1
skip4:
  add_8_8 dst, dst

  ASL src2
  BCC skip3
  add_8_8 dst, src1
skip3:
  add_8_8 dst, dst

  ASL src2
  BCC skip2
  add_8_8 dst, src1
skip2:
  add_8_8 dst, dst

  ASL src2
  BCC skip1
  add_8_8 dst, src1
skip1:
.endmacro

.macro leq_24 src1, src2, greater
  .local check2
  .local check1
  .local check0
  .local jmpPass1
  LDA src2 + 3
  CMP src1 + 3
  bcc greater
  BEQ check2
  JMP jmpPass1
check2:
  LDA src2 + 2
  CMP src1 + 2
  bcc greater
  BEQ check1
  JMP jmpPass1
check1:
  LDA src2 + 1
  CMP src1 + 1
  bcc greater
  BEQ check0
  JMP jmpPass1
check0:
  LDA src2
  CMP src1
  bcc greater
jmpPass1:
.endmacro


;.macro compare_8_8 a, b, less, eq, great
;  LDA a
;  CMP b
;  BCC less
;  BEQ eq
;  BCS great
;.endmacro