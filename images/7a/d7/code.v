module top_module(
	output	[0:3] D,
	input		E,
	input		[1:0] A
    );assign	D[0] = !A[1] && !A[0] && E,
				D[1] = !A[1] && A[0] && E,
				D[2] = A[1] && !A[0] && E,
				D[3] = A[1] && A[0] && E;

endmodule