module top_module(in0, in1, out);input [7:0] in0; 
  input [7:0] in1; 
  output [15:0] out; 
  wire signed [7:0] in1; 
  wire signed [7:0] in0; 
  wire signed [15:0] out; 
  assign out = $signed({1'b0, in0}) * in1; 
 endmodule