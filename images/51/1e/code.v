module top_module(in,out);input [15:0] in; 
 output [15:0] out; 
 assign out = {in[14:0],1'b0}; 
 endmodule