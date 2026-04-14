module top_module(
	input [15:0] num, 
	output[31:0] result 
);assign result = $signed(num);

endmodule