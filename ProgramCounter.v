//Subject:     CO project 2 - PC
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module ProgramCounter(
    clk_i,
    rst_n,
    stall_i,
    pc_in_i,
    pc_out_o
    );

//I/O ports
input           clk_i;
input           rst_n;
input           stall_i;
input  [32-1:0] pc_in_i;
output [32-1:0] pc_out_o;

//Internal Signals
reg    [32-1:0] pc_out_o;
reg    [32-1:0] pc_reg;

//Parameter


//Main function
always @(posedge clk_i) begin
    if(~rst_n)
        pc_reg <= 0;
    else if(stall_i)
        pc_reg <= pc_reg;
    else
        pc_reg <= pc_in_i;
end

always @(*) begin
    pc_out_o = pc_reg;
end

endmodule





