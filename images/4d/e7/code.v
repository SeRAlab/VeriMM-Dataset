module top_module (
	input [7:0] a,
	input [7:0] b,
	output [7:0] out_sum,
	output [7:0] out_carry);assign {out_carry[7:1], out_sum} = a + b;
assign out_carry[0] = 0;

endmodule