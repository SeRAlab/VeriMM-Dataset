module top_module(
   // Outputs
   muxed,
   // Inputs
   sa, sb, a, b
   );input sa;
   input sb;

   output wire [71:0] muxed;
   input [71:0] a;
   input [71:0] b;

   assign muxed = (sa & a) | (sb & b);
endmodule