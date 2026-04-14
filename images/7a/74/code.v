module top_module(A, B, CI, BI, X, Y, CO);parameter A_SIGNED = 0;
	parameter B_SIGNED = 0;
	parameter A_WIDTH = 1;
	parameter B_WIDTH = 1;
	parameter Y_WIDTH = 1;

	(* force_downto *)
	input [A_WIDTH-1:0] A;
	(* force_downto *)
	input [B_WIDTH-1:0] B;
	(* force_downto *)
	output [Y_WIDTH-1:0] X, Y;

	input CI, BI;
	(* force_downto *)
	output CO;

	wire [Y_WIDTH:0] C;
	wire [Y_WIDTH-1:0] S;

	// Sign extension
	wire [Y_WIDTH-1:0] A_ext;
	wire [Y_WIDTH-1:0] B_ext;
	assign A_ext = { {(Y_WIDTH-A_WIDTH){A[A_WIDTH-1]}}, A }; // Fixed sign extension
	assign B_ext = { {(Y_WIDTH-B_WIDTH){B[B_WIDTH-1]}}, B }; // Fixed sign extension

	// XOR operation
	assign S = A_ext ^ B_ext;

	// Carry-in generation
	wire CI_ext;
	assign CI_ext = BI;

	// Generate carry chain
	genvar i;
	wire [Y_WIDTH-1:0] carry;
	assign carry[0] = CI_ext;
	generate for (i = 0; i < Y_WIDTH-1; i = i + 1) begin : carry_gen
		adder_carry my_adder (
			.cin(carry[i]),
			.g(S[i]),
			.p(1'b0),
			.cout(carry[i+1]),
			.sumout(Y[i])
		);
	end endgenerate

	// Final carry-out
	assign CO = carry[Y_WIDTH-1];

	// Output carry bit
	assign X = carry[0];
endmodule