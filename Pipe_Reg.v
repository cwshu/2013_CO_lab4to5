//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg(
    clk_i,
    rst_n,
    flush_i,
    data_i,
    data_o
    );
                    
parameter size = 0;

input                  clk_i;          
input                  rst_n;
input                  flush_i;          
input      [size-1: 0] data_i;
output reg [size-1: 0] data_o;
      
always @(posedge clk_i) begin
    data_o <= data_i;
    if(rst_n == 1'b0) 
        data_o <= {size{1'b0}};
    if(flush_i == 1'b1) 
        data_o <= {size{1'b0}};
end

endmodule    
