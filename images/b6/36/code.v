module top_module(A, B, SUB, S);input [3:0] A, B;
	input SUB;
	output reg [3:0] S;

	always @(A, B, SUB) begin
		if (SUB == 1) begin
			S = A - B;
		end else begin
			S = A + B;
		end
	end

endmodule