module top_module(A, B, function_sel,
            aluout, zero_flag, parity_flag, carry_flag);output [15:0] aluout;
output zero_flag, parity_flag, carry_flag;
input [15:0] A, B;
input [3:0] function_sel;
reg [15:0] aluout;
reg zero_flag, parity_flag, carry_flag;


`define move 4'b0000 
`define comp 4'b0001 
`define and  4'b0010 
`define or   4'b0011 
`define xor  4'b0100 
`define add  4'b0101 
`define incr 4'b0110 
`define sub  4'b0111 
`define rotl 4'b1000 
`define lshl 4'b1001 
`define rotr 4'b1010 
`define lshr 4'b1011 
`define xnor 4'b1100 
`define nor  4'b1101 
`define decr 4'b1110 
`define nand 4'b1111 

always @(A or B or function_sel)
  begin
   case (function_sel)
        `move :  {carry_flag, aluout} = {1'b0, B};
        `comp :  {carry_flag, aluout} = {1'b1, ~B};
        `and  :  {carry_flag, aluout} = {1'b0, A & B};
        `or   :  {carry_flag, aluout} = {1'b0, A | B};
        `xor  :  {carry_flag, aluout} = {1'b0, A ^ B};
        `add  :  {carry_flag, aluout} = A + B;
        `incr :  {carry_flag, aluout} = B + 1;
        `sub  :  {carry_flag, aluout} = {1'b1, A} - B;
        `rotl :  {carry_flag, aluout} = {B[15:0], B[15]};
        `lshl :  {carry_flag, aluout} = {B[15:0], 1'b0};
        `rotr :  {carry_flag, aluout} = {B[0], B[0], B[15:1]};
        `lshr :  {carry_flag, aluout} = {2'b0, B[15:1]};
        `xnor :  {carry_flag, aluout} = {1'b1, A ~^ B};
        `nor  :  {carry_flag, aluout} = {1'b1, ~(A | B)};
        `decr :  {carry_flag, aluout} = B - 1;
        `nand :  {carry_flag, aluout} = {1'b1, ~(A & B)};
   endcase
   zero_flag = ~|aluout;
   parity_flag = ^aluout;
  end
endmodule