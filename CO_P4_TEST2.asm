1  ADDI R0 R1 16  # w(r1)
3  ADDI R0 R3 8   # w(r3)
10 ADDI R0 R9 100 # w(r9)
4  SW R0 R1 4     # r(r1), w(m1) 1
2  ADDI R1 R2 4   # r(r1), w(r2) 1
8  ADDI R1 R7 10  # r(r1), w(r7) 1
5  LW R0 R4 4     # r(m1), w(r4) 4
7  ADD R3 R1 R6   # r(r1, r3), w(r6) 1, 2
9  AND R7 R3 R8   # r(r3, r7), w(r8) 2, 6
6  SUB R4 R3 R5   # r(r3, r4), w(r5) 2, 7

; total cycle: 10
/*
ADDI R0 R1 16
ADDI R1 R2 4
ADDI R0 R3 8
SW R0 R1 4
LW R0 R4 4
SUB R4 R3 R5
ADD R3 R1 R6
ADDI R1 R7 10
AND R7 R3 R8
ADDI R0 R9 100
*/
