// implemented by 0016002 舒俊維 
/* 1'bit ALU

   operation
   0: AND
   1: OR
   2: 1 bit adder
   3: src2
 */
`timescale 1ns/1ps

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;
reg           cout;

wire          trans_src2;
wire          adder_result;
wire          adder_cout;

assign trans_src2 = B_invert?~src2:src2;
FA_1b FA_1b1(src1, trans_src2, cin, adder_result, adder_cout);

always@(*) begin
    result = 0;
    cout = 0;
    case(operation)
        0:  result = src1 & src2;
        1:  result = src1 | src2;
        2: begin
            result = adder_result;
            cout = adder_cout;
        end
        3:  result = src2;
    endcase
end

endmodule
