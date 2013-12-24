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

MUX_2to1 #(.size(32)) pc_branch_mux(
    .select_i(is_branch),
    .data0_i(pc_add_4),
    .data1_i(MEM_branch_addr),
    .data_o(pc_next)
    );

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_n(rst_n),
    .stall_i(pc_stall),
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
    .rst_n(rst_n),
    .stall_i(IF_ID_stall),
    .flush_i(is_branch),
    .data_i({pc_add_4, instruction}),
    .data_o({ID_pc_add_4, ID_instruction})
    );
        
//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),
    .rst_n(rst_n),
    .RegWrite_i(WB_reg_write),
    .r1_addr_i(ID_instruction[RS_S:RS_E]), // r1 => read1, w1 => write1
    .r2_addr_i(ID_instruction[RT_S:RT_E]),
    .w1_addr_i(WB_reg_w1_addr),
    .w1_data_i(reg_w1_data),
    .r1_data_o(reg_r1_data),
    .r2_data_o(reg_r2_data)
    );


Sign_Extend SE_immed(
    .data_i(ID_instruction[IMMED_S:IMMED_E]),
    .data_o(signed_ex_immed)
    );    
        
Decoder Control(
    .instr_op_i(ID_instruction[OP_S:OP_E]),
    .ALU_src2_sel_o(ALU_src2_sel),
    .reg_w1_addr_sel_o(reg_w1_addr_sel),
    .reg_w1_data_sel_o(reg_w1_data_sel),
    .branch_o(is_op_branch),
    .DM_read_o(DM_read),
    .DM_write_o(DM_write),
    .reg_write_o(reg_write),
    .ALU_op_o(small_instr_op)
    );

or is_ID_EX_flush(
    ID_EX_flush,
    is_branch,
    load_use_ID_EX_flush
    );

Pipe_Reg #(.size(163)) ID_EX(
    .clk_i(clk_i),
    .rst_n(rst_n),
    .stall_i(1'b0),
    .flush_i(ID_EX_flush),
    .data_i({ID_pc_add_4, ID_instruction[RS_S:RS_E], ID_instruction[RT_S:RT_E],
             ID_instruction[RD_S:RD_E], ID_instruction[FUNC_S:FUNC_E],
             reg_r1_data, reg_r2_data, signed_ex_immed,
             ALU_src2_sel, reg_w1_addr_sel, reg_w1_data_sel,
             is_op_branch, DM_read, DM_write, reg_write, small_instr_op
            }),
    .data_o({EX_pc_add_4, EX_instruction_RS, EX_instruction_RT,
             EX_instruction_RD, EX_instruction_func, 
             EX_reg_r1_data, EX_reg_r2_data, EX_signed_ex_immed,
             EX_ALU_src2_sel, EX_reg_w1_addr_sel, EX_reg_w1_data_sel,
             EX_is_op_branch, EX_DM_read, EX_DM_write, EX_reg_write, EX_small_instr_op
           })
    );
//Instantiate the components in EX stage       
ALU ALU(
    .rst_n(rst_n),
    .ALU_control(ALU_control),
    .bonus_control(ALU_ex_control),
    .src1(ALU_src1),
    .src2(ALU_src2),
    .result(ALU_result),
    .zero(ALU_zero),
    .cout(ALU_cout),
    .overflow(ALU_overflow)
    );
        
ALU_Ctrl ALU_Control(
    .ALU_op_i(EX_small_instr_op),
    .funct_i(EX_instruction_func),
    .ALU_ctrl_o(ALU_control),
    .ALU_ex_ctrl_o(ALU_ex_control)
    );

/* reg read data forwarding
 00: reg_rx_data,
 01, 10: MEM_forwarding, WB_forwarding,
 */
MUX_4to1 #(.size(32)) ALU_src1_mux(
    .select_i(forwarding_rs_sel),
    .data0_i(EX_reg_r1_data),
    .data1_i(MEM_ALU_result),
    .data2_i(reg_w1_data),
    .data3_i(32'b0),
    .data_o(ALU_src1)
    );

MUX_4to1 #(.size(32)) reg_r2_data_mux(
    .select_i(forwarding_rt_sel),
    .data0_i(EX_reg_r2_data),
    .data1_i(MEM_ALU_result),
    .data2_i(reg_w1_data),
    .data3_i(32'b0),
    .data_o(reg_r2_forwarding_data)
    );

MUX_4to1 #(.size(32)) ALU_src2_mux(
    .select_i(EX_ALU_src2_sel),
    .data0_i(reg_r2_forwarding_data),
    .data1_i(EX_signed_ex_immed),
    .data2_i(32'b0),
    .data3_i(32'b0),
    .data_o(ALU_src2)
    );
        
MUX_2to1 #(.size(5)) reg_w1_addr_mux(
    .select_i(EX_reg_w1_addr_sel),
    .data0_i(EX_instruction_RT),
    .data1_i(EX_instruction_RD),
    .data_o(reg_w1_addr)
    );

assign branch_addr = (EX_signed_ex_immed << 2) + EX_pc_add_4;

Pipe_Reg #(.size(107)) EX_MEM(
    .clk_i(clk_i),
    .rst_n(rst_n),
    .stall_i(1'b0),
    .flush_i(is_branch),
    .data_i({EX_reg_r2_data, reg_w1_addr, ALU_result, ALU_zero, branch_addr,
             EX_reg_w1_data_sel, EX_is_op_branch,
             EX_DM_read, EX_DM_write, EX_reg_write
            }),
    .data_o({MEM_reg_r2_data, MEM_reg_w1_addr, MEM_ALU_result, MEM_ALU_zero, MEM_branch_addr,
             MEM_reg_w1_data_sel, MEM_is_op_branch,
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

and (
    is_branch,
    MEM_is_op_branch,
    MEM_ALU_result[0]
    );

Pipe_Reg #(.size(71)) MEM_WB(
    .clk_i(clk_i),
    .rst_n(rst_n),
    .stall_i(1'b0),
    .flush_i(1'b0),
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

// data Hazard
Data_Forwarding Data_Forwarding(
    .MEM_reg_write_i(MEM_reg_write),
    .WB_reg_write_i(WB_reg_write),
    .MEM_instruction_RD_i(MEM_reg_w1_addr),
    .WB_instruction_RD_i(WB_reg_w1_addr),
    .EX_instruction_RS_i(EX_instruction_RS),
    .EX_instruction_RT_i(EX_instruction_RT),
    .forwarding_rs_o(forwarding_rs_sel),
    .forwarding_rt_o(forwarding_rt_sel)
    );

Load_Use_Stall Load_Use_Stall(
    .MEM_is_branch(is_branch),
    .EX_DM_read_i(EX_DM_read),
    .EX_instruction_RD_i(reg_w1_addr),
    .ID_instruction_RS_i(ID_instruction[RS_S:RS_E]),
    .ID_instruction_RT_i(ID_instruction[RT_S:RT_E]),
    .PC_stall_o(pc_stall),
    .IF_ID_stall_o(IF_ID_stall),
    .ID_EX_flush_o(load_use_ID_EX_flush)
    );

/****************************************
signal assignment
****************************************/    
endmodule

