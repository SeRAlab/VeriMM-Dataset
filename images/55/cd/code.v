module top_module(out, in0, in1, sel);input [15:0] in0, in1;
  input sel;
  output [15:0] out;
  
  assign out = sel ? in1 : in0;endmodule