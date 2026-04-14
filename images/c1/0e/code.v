module N8080_LOG8(
	input [7:0]A,
	input [7:0]B,
	input [3:0]op, 
	output [7:0]O
	);
	assign O[0] = op[{A[0], B[0]}];
	assign O[1] = op[{A[1], B[1]}];
	assign O[2] = op[{A[2], B[2]}];
	assign O[3] = op[{A[3], B[3]}];
	assign O[4] = op[{A[4], B[4]}];
	assign O[5] = op[{A[5], B[5]}];
	assign O[6] = op[{A[6], B[6]}];
	assign O[7] = op[{A[7], B[7]}];
endmodule