module top_module(A, B, add, clk, sum);input [31:0] A;
   input [31:0] B;
   input add;
   input clk;
   
   output [31:0] sum;
   
   wire [31:0] result;
   
   reg [31:0] sum_reg;
   
   assign result = A + B;
   
   always @ (posedge clk)
     if (add) sum_reg <= result;
   
   assign sum = add ? result : sum_reg;
endmodule