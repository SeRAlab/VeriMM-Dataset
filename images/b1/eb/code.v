module top_module(
   input [3:0] in1,
   input [3:0] in2,
   output [3:0] out1,
   output [3:0] out2
   );assign out1 = in1 - in2;
   assign out2 = in2 - in1;

endmodule