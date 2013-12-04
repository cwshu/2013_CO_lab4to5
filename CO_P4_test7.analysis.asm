/*
Init;
total=>r2; i=>r3; a=>r4; b=>r5; c=>r6
int main(){
    total=0;
    c=20;
    mem[0]=1;
    mem[1]=2;
    for(i=0; i<c ; i++){
//        a=mem[i];
//        a=a+2;
//        b=mem[i+1];
//        b=b+1;
//        total += (a+b);
        total += mem[i] + mem[i+1] + 3;
        mem[i+2]=total;
    }
}
*/

/*
Unoptimized asm

ADDI r0, r2, 0  ; total=0
ADDI r0, r6, 20 ; c=20
ADDI r0, r12, 1 ; mem[0]=1
SW   r0, r12, 0
ADDI r0, r13, 2 ; mem[1]=2
SW   r0, r13, 4

ADDI r0, r3, 0  ; i = 0
LOOP:
BEQ r3, r6, EXIT ; jump if i == c
; R10 for 4i, r4 for mem[i], r5 for mem[i+1]
    LW r10, r4, 0
    LW r10, r5, 4
    ADD r5, r2, r2   ; r2 += r4 + r5 + 3
    ADD r4, r2, r2 
    ADDI r2, r2, 3 
    SW r10, r2, 8    ; mem[i+2]=r2;
    ADDI r10, r10, 4 ; r10 += 4 (r10 = 4i)
    ADDI r3, r3, 1   ; i++
BEQ r0, r0, LOOP
EXIT:
*/

; ASM

ADDI r0, r2,  0
ADDI r0, r12, 1
ADDI r0, r13, 2
ADDI r0, r6, 20
ADDI r0, r3,  0 
SW   r0, r12, 0
SW   r0, r13, 4
LOOP:
; R10 for 4i, r4 for mem[i], r5 for mem[i+1]
    BEQ r3, r6, 12  ; jump EXIT if i == c
    LW r10, r4, 0
    LW r10, r5, 4
    ADDI r2, r2, 3   ; r2 += r12 + r13 + 3
    NOP
    ADD r4, r5, r14
    NOP
    ADDI r3, r3, 1   ; i++
    ADD r2, r14, r2
    NOP
    ADDI r10, r10, 4 ; r10 += 4 (r10 = 4i)
    SW r10, r2, 8    ; mem[i+2]=r2;
    BEQ r0, r0, -13  ; jump LOOP
EXIT:
ADDI r0, r4, 2
ADDI r0, r5, 1
