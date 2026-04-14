module combine (
	input [3:0] x,
	input [3:0] y,
	output [7:0] z);assign z = {x, y};

endmodule