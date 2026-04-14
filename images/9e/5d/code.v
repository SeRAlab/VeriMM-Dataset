module top_module(
   
   o,
   
   clk, i
   );input clk;

   input [31:0] i;
   output [31:0] o;

   assign o = i << 64'h01234567_89abcdef;

endmodule