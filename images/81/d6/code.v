module top_module(
		src_i,
		shamt_i,
		shifter_o
    );input  signed [32-1:0] src_i;
input  [5-1:0]  shamt_i;
output signed [32-1:0] shifter_o;

assign shifter_o = src_i >>> shamt_i;


endmodule