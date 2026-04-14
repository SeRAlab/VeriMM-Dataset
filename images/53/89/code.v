module top_module( clk, racc, rapx, a, b, c_in, d
 );parameter OP_BITWIDTH = 16; 
parameter DATA_PATH_BITWIDTH = 16; 


input clk;
input rapx;
input racc;
input [DATA_PATH_BITWIDTH -1:0] a;
input [DATA_PATH_BITWIDTH-1:0] b;
input [DATA_PATH_BITWIDTH-1:0] c_in; 
output [DATA_PATH_BITWIDTH-1:0] d;


assign  d = (a * b) + c_in;endmodule