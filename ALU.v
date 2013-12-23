// implemented by 0016002 舒俊維 
/* 32 bits ALU

   ALU_control
   AND  = 4'b0000,
   OR   = 4'b0001,
   ADD  = 4'b0010, 
   SUB  = 4'b0110,
   NOR  = 4'b1100, 
   NAND = 4'b1101, 
   SLL  = 4'b1000;
   SRL  = 4'b1001;
   SLT  = 4'b0111;
   MUL  = 4'b0011;
   
   bonus_control: ALU_control = 4'b0111;
   SLT = 3'b000, 
   SGT = 3'b001,
   SLE = 3'b010,
   SGE = 3'b011,
   SEQ = 3'b110, 
   SNE = 3'b100;
*/

`timescale 1ns/1ps

module ALU(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		   bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;

// opcode parameter
parameter OP_AND = 4'b0000, OP_OR = 4'b0001, OP_ADD = 4'b0010, OP_SUB = 4'b0110,
          OP_NOR = 4'b1100, OP_NAND = 4'b1101, OP_SLT = 4'b0111,
          OP_SLL = 4'b1000, OP_SRL = 4'b1001, OP_MUL = 4'b0011;

parameter OP_EX_SLT = 3'b000, OP_EX_SGT = 3'b001, OP_EX_SLE = 3'b010, OP_EX_SGE = 3'b011,
          OP_EX_SEQ = 3'b110, OP_EX_SNE = 3'b100;


// Layer 1 (32*1bit ALU)
reg  [2-1:0] ALU_1b_op;
reg  ALU_1b_B_invert;
reg  ALU_1b_c0;
wire [32-1:0] ALU_1b_c;
wire ALU_1b_c32;
wire [32-1:0] ALU_1b_res;

    // 1 bit ALU input control
always @(*) begin
    ALU_1b_op = 0;
    ALU_1b_B_invert = 0;
    ALU_1b_c0 = 0;
    case(ALU_control)
        OP_AND, OP_NAND: ALU_1b_op = 0;
        OP_OR, OP_NOR: ALU_1b_op = 1;
        OP_ADD: ALU_1b_op = 2;
        OP_SUB, OP_SLT: begin
            ALU_1b_op = 2;
            ALU_1b_B_invert = 1;
            ALU_1b_c0 = 1;
        end
        OP_SLL, OP_SRL: begin
            ALU_1b_c0 = 3;
        end
    endcase
end

    // 32 bits ALU modules
alu_top alu0 (src1[0], src2[0], ALU_1b_B_invert, ALU_1b_c0, ALU_1b_op, ALU_1b_res[0], ALU_1b_c[1]);
alu_top alu1 (src1[1], src2[1], ALU_1b_B_invert, ALU_1b_c[1], ALU_1b_op, ALU_1b_res[1], ALU_1b_c[2]);
alu_top alu2 (src1[2], src2[2], ALU_1b_B_invert, ALU_1b_c[2], ALU_1b_op, ALU_1b_res[2], ALU_1b_c[3]);
alu_top alu3 (src1[3], src2[3], ALU_1b_B_invert, ALU_1b_c[3], ALU_1b_op, ALU_1b_res[3], ALU_1b_c[4]);
alu_top alu4 (src1[4], src2[4], ALU_1b_B_invert, ALU_1b_c[4], ALU_1b_op, ALU_1b_res[4], ALU_1b_c[5]);
alu_top alu5 (src1[5], src2[5], ALU_1b_B_invert, ALU_1b_c[5], ALU_1b_op, ALU_1b_res[5], ALU_1b_c[6]);
alu_top alu6 (src1[6], src2[6], ALU_1b_B_invert, ALU_1b_c[6], ALU_1b_op, ALU_1b_res[6], ALU_1b_c[7]);
alu_top alu7 (src1[7], src2[7], ALU_1b_B_invert, ALU_1b_c[7], ALU_1b_op, ALU_1b_res[7], ALU_1b_c[8]);
alu_top alu8 (src1[8], src2[8], ALU_1b_B_invert, ALU_1b_c[8], ALU_1b_op, ALU_1b_res[8], ALU_1b_c[9]);
alu_top alu9 (src1[9], src2[9], ALU_1b_B_invert, ALU_1b_c[9], ALU_1b_op, ALU_1b_res[9], ALU_1b_c[10]);
alu_top alu10 (src1[10], src2[10], ALU_1b_B_invert, ALU_1b_c[10], ALU_1b_op, ALU_1b_res[10], ALU_1b_c[11]);
alu_top alu11 (src1[11], src2[11], ALU_1b_B_invert, ALU_1b_c[11], ALU_1b_op, ALU_1b_res[11], ALU_1b_c[12]);
alu_top alu12 (src1[12], src2[12], ALU_1b_B_invert, ALU_1b_c[12], ALU_1b_op, ALU_1b_res[12], ALU_1b_c[13]);
alu_top alu13 (src1[13], src2[13], ALU_1b_B_invert, ALU_1b_c[13], ALU_1b_op, ALU_1b_res[13], ALU_1b_c[14]);
alu_top alu14 (src1[14], src2[14], ALU_1b_B_invert, ALU_1b_c[14], ALU_1b_op, ALU_1b_res[14], ALU_1b_c[15]);
alu_top alu15 (src1[15], src2[15], ALU_1b_B_invert, ALU_1b_c[15], ALU_1b_op, ALU_1b_res[15], ALU_1b_c[16]);
alu_top alu16 (src1[16], src2[16], ALU_1b_B_invert, ALU_1b_c[16], ALU_1b_op, ALU_1b_res[16], ALU_1b_c[17]);
alu_top alu17 (src1[17], src2[17], ALU_1b_B_invert, ALU_1b_c[17], ALU_1b_op, ALU_1b_res[17], ALU_1b_c[18]);
alu_top alu18 (src1[18], src2[18], ALU_1b_B_invert, ALU_1b_c[18], ALU_1b_op, ALU_1b_res[18], ALU_1b_c[19]);
alu_top alu19 (src1[19], src2[19], ALU_1b_B_invert, ALU_1b_c[19], ALU_1b_op, ALU_1b_res[19], ALU_1b_c[20]);
alu_top alu20 (src1[20], src2[20], ALU_1b_B_invert, ALU_1b_c[20], ALU_1b_op, ALU_1b_res[20], ALU_1b_c[21]);
alu_top alu21 (src1[21], src2[21], ALU_1b_B_invert, ALU_1b_c[21], ALU_1b_op, ALU_1b_res[21], ALU_1b_c[22]);
alu_top alu22 (src1[22], src2[22], ALU_1b_B_invert, ALU_1b_c[22], ALU_1b_op, ALU_1b_res[22], ALU_1b_c[23]);
alu_top alu23 (src1[23], src2[23], ALU_1b_B_invert, ALU_1b_c[23], ALU_1b_op, ALU_1b_res[23], ALU_1b_c[24]);
alu_top alu24 (src1[24], src2[24], ALU_1b_B_invert, ALU_1b_c[24], ALU_1b_op, ALU_1b_res[24], ALU_1b_c[25]);
alu_top alu25 (src1[25], src2[25], ALU_1b_B_invert, ALU_1b_c[25], ALU_1b_op, ALU_1b_res[25], ALU_1b_c[26]);
alu_top alu26 (src1[26], src2[26], ALU_1b_B_invert, ALU_1b_c[26], ALU_1b_op, ALU_1b_res[26], ALU_1b_c[27]);
alu_top alu27 (src1[27], src2[27], ALU_1b_B_invert, ALU_1b_c[27], ALU_1b_op, ALU_1b_res[27], ALU_1b_c[28]);
alu_top alu28 (src1[28], src2[28], ALU_1b_B_invert, ALU_1b_c[28], ALU_1b_op, ALU_1b_res[28], ALU_1b_c[29]);
alu_top alu29 (src1[29], src2[29], ALU_1b_B_invert, ALU_1b_c[29], ALU_1b_op, ALU_1b_res[29], ALU_1b_c[30]);
alu_top alu30 (src1[30], src2[30], ALU_1b_B_invert, ALU_1b_c[30], ALU_1b_op, ALU_1b_res[30], ALU_1b_c[31]);
alu_top alu31 (src1[31], src2[31], ALU_1b_B_invert, ALU_1b_c[31], ALU_1b_op, ALU_1b_res[31], ALU_1b_c32);
// Layer 1 end

// Layer 2
wire slt;
wire seq;
wire sgt;
wire sle;
wire sge;
wire sne;

always @(*) begin
    result = 0;
    zero = 0;
    cout = 0;
    overflow = 0;
    if(rst_n == 1) begin
        cout = ALU_1b_c32;
        overflow = ALU_1b_c[31] ^ ALU_1b_c32;

        case(ALU_control)
            OP_AND, OP_OR, OP_ADD, OP_SUB: result = ALU_1b_res;
            OP_NAND, OP_NOR: result = ~ALU_1b_res;
            OP_SLT: begin
                cout = 0;
                case(bonus_control)
                    OP_EX_SLT: result = slt;
                    OP_EX_SGT: result = sgt;
                    OP_EX_SLE: result = sle;
                    OP_EX_SGE: result = sge;
                    OP_EX_SEQ: result = seq;
                    OP_EX_SNE: result = sne;
                endcase
            end
            OP_SLL: result = ALU_1b_res << src1;
            OP_SRL: result = ALU_1b_res >> src2;
            OP_MUL: result = src1*src2;
        endcase

        zero = (result == 0);
    end    
end

assign slt = ALU_1b_res[31];
assign seq = ~(ALU_1b_res[0] | ALU_1b_res[1] | ALU_1b_res[2] | ALU_1b_res[3] | ALU_1b_res[4] | ALU_1b_res[5] | ALU_1b_res[6] | ALU_1b_res[7] | ALU_1b_res[8] | ALU_1b_res[9] | ALU_1b_res[10] | ALU_1b_res[11] | ALU_1b_res[12] | ALU_1b_res[13] | ALU_1b_res[14] | ALU_1b_res[15] | ALU_1b_res[16] | ALU_1b_res[17] | ALU_1b_res[18] | ALU_1b_res[19] | ALU_1b_res[20] | ALU_1b_res[21] | ALU_1b_res[22] | ALU_1b_res[23] | ALU_1b_res[24] | ALU_1b_res[25] | ALU_1b_res[26] | ALU_1b_res[27] | ALU_1b_res[28] | ALU_1b_res[29] | ALU_1b_res[30] | ALU_1b_res[31]);
assign sgt = !(slt || seq);
assign sle = slt || seq;
assign sge = !slt;
assign sne = !seq;
// layer 2 end

endmodule
