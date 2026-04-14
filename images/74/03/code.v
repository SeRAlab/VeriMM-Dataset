module top_module(
   input [11:0] a,
   input [11:0] b,
   input gt, 
   input lt, 
   input et, 
   output y
   );assign y = ((a > b) && gt) || ((a == b) && et) || ((a < b) && lt);

endmodule