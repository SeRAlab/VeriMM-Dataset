module top_module(sum, carry_out, a, b, carry_in);output [31:0] sum;
   output        carry_out;
   input  [31:0] a, b;
   input         carry_in;

   wire   [31:0] Sum;
   wire          carry_out; 
	
	assign {carry_out, sum} = a + b + carry_in;
	
	
endmodule