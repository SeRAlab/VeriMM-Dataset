module top_module(
   // Inputs
   a,
   clk,
   // Outputs
   q
   );input [125:0] a;
   input clk;
   output q;

   assign q = a[125] & a[0];

endmodule