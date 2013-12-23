module Data_Forwarding(
    MEM_reg_write_i,
    WB_reg_write_i,
    MEM_instruction_RD_i,
    WB_instruction_RD_i,
    EX_instruction_RS_i,
    EX_instruction_RT_i,
    forwarding_rs_o,
    forwarding_rt_o
    );

input MEM_reg_write_i;
input WB_reg_write_i;
input [5-1:0] MEM_instruction_RD_i;
input [5-1:0] WB_instruction_RD_i;
input [5-1:0] EX_instruction_RS_i;
input [5-1:0] EX_instruction_RT_i;
output reg [2-1:0] forwarding_rs_o;
output reg [2-1:0] forwarding_rt_o;

parameter FORWORD_ORI = 2'b00, FORWORD_MEM = 2'b01, FORWORD_WB = 2'b10;

always @(*) begin
    forwarding_rs_o = FORWORD_ORI;
    if(MEM_instruction_RD_i != 0 && MEM_instruction_RD_i == EX_instruction_RS_i) begin
        forwarding_rs_o = FORWORD_MEM;        
    end
    else if(WB_instruction_RD_i != 0 && WB_instruction_RD_i == EX_instruction_RS_i) begin
        forwarding_rs_o = FORWORD_WB;
    end
end

always @(*) begin
    forwarding_rt_o = FORWORD_ORI;
    if(MEM_instruction_RD_i != 0 && MEM_instruction_RD_i == EX_instruction_RT_i) begin
        forwarding_rt_o = FORWORD_MEM;        
    end
    else if(WB_instruction_RD_i != 0 && WB_instruction_RD_i == EX_instruction_RT_i) begin
        forwarding_rt_o = FORWORD_WB;
    end
end

endmodule
