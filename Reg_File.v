//Subject:     CO project 2 - Register File
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module Reg_File(
    clk_i,
    rst_n,
    RegWrite_i,
    r1_addr_i,
    r2_addr_i,
    w1_addr_i,
    w1_data_i,
    r1_data_o,
    r2_data_o
    );

//I/O ports
input           clk_i;
input           rst_n;
input           RegWrite_i;
input  [5-1:0]  r1_addr_i;
input  [5-1:0]  r2_addr_i;
input  [5-1:0]  w1_addr_i;
input  [32-1:0] w1_data_i;

output [32-1:0] r1_data_o;
output [32-1:0] r2_data_o;

//Internal signals/registers
reg  signed [32-1:0] Reg_File [0:32-1];     //32 word registers
wire        [32-1:0] r1_data_o;
wire        [32-1:0] r2_data_o;

//Read the data
assign r1_data_o = Reg_File[r1_addr_i] ;
assign r2_data_o = Reg_File[r2_addr_i] ;

//Writing data when postive edge clk_i and RegWrite_i was set.
always @( negedge rst_n or negedge clk_i) begin
    if(rst_n == 0) begin
        Reg_File[0]  <= 0; Reg_File[1]  <= 0; Reg_File[2]  <= 0; Reg_File[3]  <= 0;
        Reg_File[4]  <= 0; Reg_File[5]  <= 0; Reg_File[6]  <= 0; Reg_File[7]  <= 0;
        Reg_File[8]  <= 0; Reg_File[9]  <= 0; Reg_File[10] <= 0; Reg_File[11] <= 0;
        Reg_File[12] <= 0; Reg_File[13] <= 0; Reg_File[14] <= 0; Reg_File[15] <= 0;
        Reg_File[16] <= 0; Reg_File[17] <= 0; Reg_File[18] <= 0; Reg_File[19] <= 0;
        Reg_File[20] <= 0; Reg_File[21] <= 0; Reg_File[22] <= 0; Reg_File[23] <= 0;
        Reg_File[24] <= 0; Reg_File[25] <= 0; Reg_File[26] <= 0; Reg_File[27] <= 0;
        Reg_File[28] <= 0; Reg_File[29] <= 0; Reg_File[30] <= 0; Reg_File[31] <= 0;
    end
    else begin
        if(RegWrite_i)
            Reg_File[w1_addr_i] <= w1_data_i;
        else
            Reg_File[w1_addr_i] <= Reg_File[w1_addr_i];
    end
end

endmodule
