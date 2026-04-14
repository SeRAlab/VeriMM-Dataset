module top_module(clk, din, ld, clr, q);input clk, ld, clr;
	input [3:0] din;
	output [3:0] q;
	reg [3:0] q;

	// Asynchronous clear
	always @ (posedge clk, negedge clr) begin
		if (clr == 1) begin
			q <= 4'b0;
		end
	end

	// Parallel load
	always @ (posedge clk) begin
		if (ld == 1) begin
			q <= din;
		end
	end

endmodule