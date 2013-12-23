// implemented by 0016002 舒俊維 

// NOP = AND r0, r0, r0
module Decoder(
    instr_op_i,
    ALU_src2_sel_o,
    reg_w1_addr_sel_o,
    reg_w1_data_sel_o,
    branch_o,
    DM_read_o,
    DM_write_o,
    reg_write_o,
    ALU_op_o
    );

//I/O ports
input  [6-1:0] instr_op_i;

output reg [2-1:0] ALU_src2_sel_o;
output reg         reg_w1_addr_sel_o;
output reg         reg_w1_data_sel_o;
output reg         branch_o;
output reg         DM_read_o;
output reg         DM_write_o;
output reg         reg_write_o;
output     [6-1:0] ALU_op_o;

//Internal Signals

//Parameter
parameter CPU_OP_R_ARITHMETIC = 6'b000000, CPU_OP_ADDI = 6'b001000,
          CPU_OP_ORI = 6'b001101, CPU_OP_BEQ = 6'b000100,
          CPU_OP_LW = 6'b100011, CPU_OP_SW = 6'b101011,
          CPU_OP_BGT = 6'b000111, CPU_OP_BNEZ = 6'b000101, CPU_OP_BGEZ = 6'b000001;

parameter ALUSRC2_REG = 2'b00, ALUSRC2_IMMED = 2'b01, ALUSRC2_0 = 2'b10;
parameter REG_W1_ADDR_RT = 1'b0, REG_W1_ADDR_RD = 1'b1;
parameter REG_W1_DATA_ALU = 1'b0, REG_W1_DATA_DM = 1'b1;
// parameter SE_EXTEN = 1'b0, ZE_EXTEN = 1'b1;

//Main function
assign ALU_op_o = instr_op_i;

always @(*) begin
    ALU_src2_sel_o = ALUSRC2_REG;
    reg_w1_addr_sel_o = REG_W1_ADDR_RD;
    reg_w1_data_sel_o = REG_W1_DATA_ALU;
    branch_o = 1'b0;
    DM_read_o = 1'b0;
    DM_write_o = 1'b0;
    reg_write_o = 1'b0;

    case(instr_op_i)
        CPU_OP_ADDI, CPU_OP_LW, CPU_OP_SW: ALU_src2_sel_o = ALUSRC2_IMMED;
        CPU_OP_BGEZ, CPU_OP_BNEZ: ALU_src2_sel_o = ALUSRC2_0;
    endcase
    case(instr_op_i)
        CPU_OP_ADDI, CPU_OP_LW: reg_w1_addr_sel_o = REG_W1_ADDR_RT;
    endcase
    case(instr_op_i)
        CPU_OP_LW: reg_w1_data_sel_o = REG_W1_DATA_DM;
    endcase
    case(instr_op_i)
        CPU_OP_LW: DM_read_o = 1'b1;
    endcase
    case(instr_op_i)
        CPU_OP_SW: DM_write_o = 1'b1;
    endcase
    case(instr_op_i)
        CPU_OP_R_ARITHMETIC, CPU_OP_ADDI, CPU_OP_LW: reg_write_o = 1'b1;
    endcase
    case(instr_op_i)
        CPU_OP_BEQ, CPU_OP_BGT, CPU_OP_BGEZ, CPU_OP_BNEZ: branch_o = 1'b1;
    endcase
end

endmodule







