module top_module(in2, in1, out);input [31:0] in1; 
 input [25:0] in2; 
 output [31:0] out; 
 assign out [31:28] = in1 [31:28]; 
 assign out [27:2] = in2 [25:0]; 
 assign out [1:0] = 2'b00; 
 wire useless_inputs; 
 assign useless_inputs = |in1 & |in2; 
 endmodule