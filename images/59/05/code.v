module top_module(
	input signed [2:0] A,
	input signed [2:0] B,
	input carry_in,
	output signed [3:0] Sum  
	);assign Sum = A + B + $signed({1'b0, carry_in});
endmodule