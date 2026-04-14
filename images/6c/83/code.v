module top_module(
	input [17:0] A,
	input [17:0] B,
	input CLK,
	input RST,
	output [35:0] Z
);reg signed [35:0] mult_result;
	reg [35:0] abs_a;
	reg [35:0] abs_b;
	reg [35:0] abs_result;

	always @(posedge CLK or posedge RST) begin
		if (RST) begin
			mult_result <= 0;
			abs_a <= 0;
			abs_b <= 0;
			abs_result <= 0;
		end else begin
			abs_a <= { {18{A[17]}}, A };
			abs_b <= { {18{B[17]}}, B };
			abs_result <= abs_a * abs_b;
			if (A[17] ^ B[17])
				mult_result <= ~abs_result + 1;
			else
				mult_result <= abs_result;
		end
	end

	assign Z = mult_result;

endmodule