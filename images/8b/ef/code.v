module top_module(
	input [3:0] A,
	input [3:0] B,
	input C_in,
	input clk,
	output reg [3:0] S,    // Change output to reg
	output reg C_out       // Change output to reg
);always @(posedge clk) begin
		// calculate the sum of A, B, and C_in
		S <= A + B + C_in;

		// calculate the carry-out bit
		C_out <= ((A[3] & B[3]) | (A[3] & C_in) | (B[3] & C_in));
	end

endmodule