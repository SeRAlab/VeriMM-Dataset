module top_module(out, a, b);output    [31:0]  out;
   input   signed [31:0] a;
   input   signed [31:0] b;

   wire  signed [31:0]   out;
   wire  signed [63:0]   mult_out;

   assign mult_out = a * b;
   
   assign out = {mult_out[63], mult_out[59:30]};
endmodule