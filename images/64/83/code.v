module top_module (
	input x,
	input y,
	output reg z);assign z = ~(x & y);
endmodule