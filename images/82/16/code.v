module top_module(in,out,CD,CU,L,R);parameter szerokosc = 4;
input [szerokosc-1:0] in;
input CD,CU,L,R;
output out;
assign out=(&{in[szerokosc-1],~in[szerokosc-2:0],~CU,~L,~R}|&{~in[szerokosc-1],in[szerokosc-2:0],~CD,~L,~R});endmodule