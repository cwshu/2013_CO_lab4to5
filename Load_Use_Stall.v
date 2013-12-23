module Load_Use_Stall(
    EX_DM_read_i,
    EX_instruction_RD_i,
    ID_instruction_RS_i,
    ID_instruction_RT_i,
    PC_stall_o,
    IF_ID_stall_o,
    ID_EX_flush_o
    );
input EX_DM_read_i;
input [5-1:0] EX_instruction_RD_i;
input [5-1:0] ID_instruction_RS_i;
input [5-1:0] ID_instruction_RT_i;
output reg PC_stall_o;
output reg IF_ID_stall_o;
output reg ID_EX_flush_o;

always @(*) begin 
    PC_stall_o = 1'b0;
    IF_ID_stall_o = 1'b0;
    ID_EX_flush_o = 1'b0;
    if(EX_DM_read_i) begin
        if(EX_instruction_RD_i == ID_instruction_RS_i) begin
            PC_stall_o = 1'b1;
            IF_ID_stall_o = 1'b1;
            ID_EX_flush_o = 1'b1;
        end 
        else if(EX_instruction_RD_i == ID_instruction_RT_i) begin
            PC_stall_o = 1'b1;
            IF_ID_stall_o = 1'b1;
            ID_EX_flush_o = 1'b1;
        end
    end
end

endmodule
