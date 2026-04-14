module top_module(a,b,sel,out);input a,b;
input sel;
output out;
assign out = a & (~sel) | b & sel;endmodule