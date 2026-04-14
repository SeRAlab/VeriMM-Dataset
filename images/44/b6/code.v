module top_module (
	input x1,
	input x2,
	input x3,
	output reg z);assign z = ~((~(x1 & x2)) | x3);
endmodule