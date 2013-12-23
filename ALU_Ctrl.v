// implemented by 0016002 舒俊維 

module ALU_Ctrl(
          ALU_op_i,
          funct_i,
          ALU_ctrl_o,
          ALU_ex_ctrl_o
          );

//I/O ports
input      [6-1:0] funct_i;
input      [6-1:0] ALU_op_i;

output reg [4-1:0] ALU_ctrl_o;
output reg [3-1:0] ALU_ex_ctrl_o;
// output     ALUSrc_shamt_o;

//Internal Signals

//Parameter
parameter CPU_FUNC_ADD = 6'b100000, CPU_FUNC_SUB = 6'b100010, CPU_FUNC_AND = 6'b100100,
          CPU_FUNC_OR = 6'b100101, CPU_FUNC_SLT = 6'b101010, CPU_FUNC_MUL = 6'b011000;
//          CPU_FUNC_SLL = 6'b000000, CPU_FUNC_SLLV = 6'b000100,
//          CPU_FUNC_SRL = 6'b000010, CPU_FUNC_SRLV = 6'b000110;

parameter CPU_OP_R_ARITHMETIC = 6'b000000, CPU_OP_ADDI = 6'b001000,
          CPU_OP_ORI = 6'b001101, CPU_OP_BEQ = 6'b000100,
          CPU_OP_LW = 6'b100011, CPU_OP_SW = 6'b101011,
          CPU_OP_BGT = 6'b000111, CPU_OP_BNEZ = 6'b000101, CPU_OP_BGEZ = 6'b000001;

parameter ALU_OP_AND = 4'b0000, ALU_OP_OR = 4'b0001, ALU_OP_ADD = 4'b0010, ALU_OP_SUB = 4'b0110,
          ALU_OP_NOR = 4'b1100, ALU_OP_NAND = 4'b1101, ALU_OP_SLT = 4'b0111,
          ALU_OP_SLL = 4'b1000, ALU_OP_SRL = 4'b1001, ALU_OP_MUL = 4'b0011,
          ALU_EX_OP_SGT = 3'b001, ALU_EX_OP_SNE = 3'b100, ALU_EX_OP_SEQ = 3'b100,
          ALU_EX_OP_SGE = 3'b011;


//Select exact operation
always @(*) begin
    ALU_ctrl_o = 4'b0;
    ALU_ex_ctrl_o = 3'b0;

    case(ALU_op_i)
        CPU_OP_R_ARITHMETIC: begin
            case(funct_i)
                CPU_FUNC_ADD : ALU_ctrl_o = ALU_OP_ADD;
                CPU_FUNC_SUB : ALU_ctrl_o = ALU_OP_SUB;
                CPU_FUNC_AND : ALU_ctrl_o = ALU_OP_AND;
                CPU_FUNC_OR  : ALU_ctrl_o = ALU_OP_OR;
                CPU_FUNC_SLT : ALU_ctrl_o = ALU_OP_SLT;
                CPU_FUNC_MUL : ALU_ctrl_o = ALU_OP_MUL;
            endcase
        end
        CPU_OP_ADDI, CPU_OP_LW, CPU_OP_SW: ALU_ctrl_o = ALU_OP_ADD;
        CPU_OP_BEQ, CPU_OP_BGT, CPU_OP_BNEZ, CPU_OP_BGEZ: ALU_ctrl_o = ALU_OP_SLT;
    endcase

    case(ALU_op_i)
        CPU_OP_BEQ: ALU_ex_ctrl_o = ALU_EX_OP_SEQ;
        CPU_OP_BGT: ALU_ex_ctrl_o = ALU_EX_OP_SGT;
        CPU_OP_BGEZ: ALU_ex_ctrl_o = ALU_EX_OP_SGE;
        CPU_OP_BNEZ: ALU_ex_ctrl_o = ALU_EX_OP_SNE;
    endcase
end

endmodule







