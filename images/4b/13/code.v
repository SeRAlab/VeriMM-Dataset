module top_module(clk, subkey, diff_out, keyadd_out);input clk;
input [127:0] subkey, diff_out;
output [127:0] keyadd_out;

assign keyadd_out = subkey ^ diff_out;  
endmodule