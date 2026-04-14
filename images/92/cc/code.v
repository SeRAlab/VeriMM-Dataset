module top_module(
   input          b,
   input [1:0]    s,
   output [1:0]   n,
   output         x);assign n[1] = ~s[1] & s[0] | s[1] & ~s[0];
   assign n[0] = s[1] & ~s[0] | ~s[0] & b;
   assign x    = s[1] | s[0];
   
endmodule