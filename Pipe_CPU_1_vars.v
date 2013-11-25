/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [32-1:0] pc_next;
wire [32-1:0] pc_out;
wire [32-1:0] instruction;
wire [32-1:0] pc_add_4;

/**** ID stage ****/
wire [32-1:0] ID_pc_add_4;
wire [32-1:0] ID_instruction;

wire [32-1:0] reg_r1_data;
wire [32-1:0] reg_r2_data;
wire [32-1:0] signed_ex_immed;
// control signal
// Decoder
wire ALU_src2_sel, reg_w1_addr_sel, reg_w1_data_sel;
wire pc_branch_sel;
wire DM_read, DM_write, reg_write;
wire small_instr_op;


/**** EX stage ****/
wire [32-1:0] EX_pc_add_4;
wire [5-1:0]  EX_instruction_RT;
wire [5-1:0]  EX_instruction_RD;
wire [6-1:0]  EX_instruction_func;
wire [32-1:0] EX_reg_r1_data;
wire [32-1:0] EX_reg_r2_data;
wire [32-1:0] EX_reg_w1_addr;
wire [32-1:0] EX_signed_ex_immed;

wire [32-1:0] ALU_src2;

wire [32-1:0] ALU_result;
wire ALU_zero;
wire ALU_cout;
wire ALU_overflow;
// control signal
wire EX_ALU_src2_sel, EX_reg_w1_addr_sel, EX_reg_w1_data_sel;
wire EX_pc_branch_sel;
wire EX_DM_read, EX_DM_write, EX_reg_write;
wire EX_small_instr_op;

wire [3-1:0] ALU_control;

/**** MEM stage ****/
wire [32-1:0] MEM_reg_r2_data;
wire [32-1:0] MEM_reg_w1_addr;
wire [32-1:0] MEM_ALU_result;
wire MEM_ALU_zero;

wire [32-1:0] DM_out;
// control signal
wire MEM_reg_w1_data_sel;
wire MEM_pc_branch_sel;
wire MEM_DM_read, MEM_DM_write, MEM_reg_write;


/**** WB stage ****/
wire [32-1:0] WB_reg_w1_addr;
wire [32-1:0] WB_ALU_result;
wire [32-1:0] WB_DM_out;

wire [32-1:0] reg_w1_data;
// control signal
wire WB_reg_write;
wire WB_reg_w1_data_sel;


// constant
// Instruction components start/end bit
parameter OP_S = 31, OP_E = 26, RS_S = 25, RS_E = 21, RT_S = 20, RT_E = 16, RD_S = 15, RD_E = 11,
          SHAMT_S = 10, SHAMT_E = 6, FUNC_S = 5, FUNC_E = 0,
          IMMED_S = 15, IMMED_E = 0,
          J_IMMED_S = 25, J_IMMED_E = 0;

// control signal
/*
    ALU_src2_sel, reg_w1_addr_sel, reg_w1_data_sel
    pc_branch_sel
    DM_read, DM_write, reg_write
    ALU_op
 */
