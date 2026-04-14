module top_module(result,din);output [15:0]result;
input [15:0]din;
assign result=din<<1;
endmodule