module top_module(a, b, sum, c_out);input [3:0] a, b;
   output [4:0] sum;
   output c_out;
   wire [3:0] carry;
   
   assign sum = a + b;
   assign carry = {a[3], b[3], sum[3]} == 3'b001 || {a[3], b[3], sum[3]} == 3'b010 || {a[3], b[3], sum[3]} == 3'b100;
   assign c_out = carry[3];
   
endmodule