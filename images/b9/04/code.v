module top_module( vra, vrb, vrt, sat );input  [31 : 0] vra;
input  [31 : 0] vrb;
output [31 : 0] vrt;
output          sat;

wire   [31 : 0] sum;
wire   [31 : 0] vrt;
wire            sat;

assign {sat, sum}	= vra + vrb;
assign vrt = (vra[31]^vrb[31]) ? sum : (vra[31]&&vrb[31] ? (sum[31] ? sum : 32'h80000000) : (sum[31] ? 32'h7fffffff : sum));

endmodule