module top_module(input signed [2:0] a,input [2:0] b,output signed [5:0] prod);assign prod = a*$signed({1'b0, b}); 
 endmodule