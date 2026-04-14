module top_module(input [8 - 1:0] in0,input [22 - 1:0] in1,input [30 - 1:0] in2,output [32 - 1:0] dout);wire signed [25 - 1:0] a; 
 wire signed [18 - 1:0] b; 
 wire signed [48 - 1:0] c; 
 wire signed [43 - 1:0] m; 
 wire signed [48 - 1:0] p; 
 assign a = $signed(in1); 
 assign b = $signed(in0); 
 assign c = $unsigned(in2); 
 assign m = a * b; 
 assign p = m + c; 
 assign dout = p; 
 endmodule