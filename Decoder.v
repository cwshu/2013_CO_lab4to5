// implemented by 0016002 舒俊維 

module Decoder(
    instr_op_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
    immed_exten
    );

//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [6-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         immed_exten;

//Internal Signals
//reg    [6-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            immed_exten;

//Parameter
parameter CPU_OP_R_ARITHMETIC = 6'b000000, CPU_OP_ADDI = 6'b001000,
          CPU_OP_ORI = 6'b001101, CPU_OP_BEQ = 6'b000100;

parameter ALUSRC_REG = 1'b0, ALUSRC_IMMED = 1'b1;
parameter REGDST_RT = 1'b0, REGDST_RD = 1'b1;
parameter SE_EXTEN = 1'b0, ZE_EXTEN = 1'b1;

//Main function
assign ALU_op_o = instr_op_i;

always @(*) begin
    ALUSrc_o = 1'b1;
    RegWrite_o = 1'b1;
    RegDst_o = REGDST_RT;
    Branch_o = 1'b0;
    immed_exten = SE_EXTEN;

    if(instr_op_i == CPU_OP_R_ARITHMETIC || instr_op_i == CPU_OP_BEQ) begin
        ALUSrc_o = ALUSRC_REG;
    end
    if(instr_op_i == CPU_OP_BEQ) begin
        RegWrite_o = 1'b0;
    end
    if(instr_op_i == CPU_OP_R_ARITHMETIC) begin
        RegDst_o = REGDST_RD;
    end
    if(instr_op_i == CPU_OP_BEQ) begin
        Branch_o = 1'b1;
    end
    if(instr_op_i == CPU_OP_ORI) begin
        immed_exten = ZE_EXTEN;
    end

end

endmodule







