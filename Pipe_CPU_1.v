//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_n
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_n;

/****************************************
Internal signal
****************************************/
`include "./Pipe_CPU_1_vars.v"

/**
 * Instantiate modules
 */
// Instantiate the components in IF stage
ProgramCounter PC(
    .clk_i(clk_i),
    .rst_n(rst_n),
    .pc_in_i(pc_next),
    .pc_out_o(pc_out)
    );

Instr_Memory IM(
    .pc_addr_i(pc_out),
    .instr_o(instruction)
    );
            
Adder Add_pc(
    .src1_i(pc_out),
    .src2_i(32'd4),
    .sum_o(pc_add_4)
    );

        
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
    .clk_i(clk_i),
    .data_i({pc_add_4, instruction}),
    .data_o({ID_pc_add_4, ID_instruction})
    );
        
//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),
    .rst_n(rst_n),
    .RegWrite_i(is_write_reg),
    .r1_addr_i(instruction[RS_S:RS_E]), // r1 => read1, w1 => write1
    .r2_addr_i(instruction[RT_S:RT_E]),
    .w1_addr_i(WB_reg_w1_addr),
    .w1_data_i(reg_w1_data),
    .r1_data_o(reg_r1_data),
    .r2_data_o(reg_r2_data)
    );


Sign_Extend SE_immed(
    .data_i(instruction[IMMED_S:IMMED_E]),
    .data_o(signed_ex_immed)
    );    
        
Decoder Control(
    .instr_op_i(instruction[OP_S:OP_E]),
    .ALU_src2_sel_o(ALU_src2_sel),
    .reg_w1_addr_sel_o(reg_w1_addr_sel),
    .reg_w1_data_sel_o(reg_w1_data_sel),
    .branch_o(pc_branch_sel),
    .DM_read_o(DM_read),
    .DM_write_o(DM_write),
    .reg_write_o(reg_write),
    .ALU_op_o(small_instr_op)
    );

Pipe_Reg #(.size(157)) ID_EX(
    .clk_i(clk_i),
    .data_i({ID_pc_add_4, instruction[RT_S:RT_E], instruction[RD_S:RD_E], instruction[FUNC_S:FUNC_E],
             reg_r1_data, reg_r2_data, signed_ex_immed,
             ALU_src2_sel, reg_w1_addr_sel, reg_w1_data_sel,
             pc_branch_sel, DM_read, DM_write, reg_write, small_instr_op
            }),
    .data_o({EX_pc_add_4, EX_instruction_RT, EX_instruction_RD, EX_instruction_func, 
             EX_reg_r1_data, EX_reg_r2_data, EX_signed_ex_immed,
             EX_ALU_src2_sel, EX_reg_w1_addr_sel, EX_reg_w1_data_sel,
             EX_pc_branch_sel, EX_DM_read, EX_DM_write, EX_reg_write, EX_small_instr_op
           })
    );
//Instantiate the components in EX stage       
ALU ALU(
    .rst_n(rst_n),
    .ALU_control(ALU_control),
    .bonus_control(3'b0),
    .src1(EX_reg_r1_data),
    .src2(ALU_src2),
    .result(ALU_result),
    .zero(ALU_zero),
    .cout(ALU_cout),
    .overflow(ALU_overflow)
    );
        
ALU_Ctrl ALU_Control(
    .ALU_op_i(small_instr_op),
    .funct_i(EX_instruction_func),
    .ALU_ctrl_o(ALU_control)
    );

MUX_2to1 #(.size(32)) ALU_src2_mux(
    .select_i(EX_ALU_src2_sel),
    .data0_i(EX_reg_r2_data),
    .data1_i(signed_ex_immed),
    .data_o(ALU_src2)
    );
        
MUX_2to1 #(.size(5)) reg_w1_addr_mux(
    .select_i(EX_reg_w1_addr_sel),
    .data0_i(EX_instruction_RT),
    .data1_i(EX_instruction_RD),
    .data_o(reg_w1_addr)
    );

Pipe_Reg #(.size(75)) EX_MEM(
    .data_i({EX_reg_r2_data, reg_w1_addr, ALU_result, ALU_zero,
             EX_reg_w1_data_sel, EX_pc_branch_sel,
             EX_DM_read, EX_DM_write, EX_reg_write
            }),
    .data_o({MEM_reg_r2_data, MEM_reg_w1_addr, MEM_ALU_result, MEM_ALU_zero,
             MEM_reg_w1_data_sel, MEM_pc_branch_sel,
             MEM_DM_read, MEM_DM_write, MEM_reg_write
            })
    );
//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i(clk_i),
    .MemRead_i(MEM_DM_read),
    .MemWrite_i(MEM_DM_write),
    .addr_i(MEM_ALU_result),
    .data_i(MEM_reg_r2_data),
    .data_o(DM_out)
    );

Pipe_Reg #(.size(71)) MEM_WB(
    .data_i({MEM_reg_w1_addr, MEM_ALU_result, DM_out, MEM_reg_write, MEM_reg_w1_data_sel}),
    .data_o({WB_reg_w1_addr, WB_ALU_result, WB_DM_out, WB_reg_write, WB_reg_w1_data_sel})
    );

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) reg_w1_data_mux(
    .select_i(WB_reg_w1_data_sel),
    .data0_i(WB_ALU_result),
    .data1_i(WB_DM_out),
    .data_o(reg_w1_data)
    );

/****************************************
signal assignment
****************************************/    
endmodule

