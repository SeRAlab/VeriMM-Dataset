module top_module(input [5 - 1:0] in0,input [2 - 1:0] in1,input [6 - 1:0] in2,output [9 - 1:0] dout);wire signed [18 - 1:0] b; 
 wire signed [25 - 1:0] a; 
 wire signed [25 - 1:0] d; 
 wire signed [43 - 1:0] m; 
 wire signed [25 - 1:0] ad; 
 assign a = $signed(in0); 
 assign d = $unsigned(in1); 
 assign b = $unsigned(in2); 
 assign ad = a + d; 
 assign m = ad * b; 
 assign dout = m; 
 endmodule