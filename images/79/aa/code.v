module top_module(input [8 - 1:0] in0,input [20 - 1:0] in1,input [29 - 1:0] in2,output [29 - 1:0] dout);wire signed [25 - 1:0] a; 
 wire signed [18 - 1:0] b; 
 wire signed [48 - 1:0] c; 
 wire signed [43 - 1:0] m; 
 wire signed [48 - 1:0] p; 
 assign a = $unsigned(in1); 
 assign b = $unsigned(in0); 
 assign c = $unsigned(in2); 
 assign m = a * b; 
 assign p = m + c; 
 assign dout = p; 
 endmodule