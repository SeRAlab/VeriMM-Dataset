module top_module(
	input clk,
	output [9:0] prbs);reg [9:0] lfsr;

	always @(posedge clk) begin
		lfsr <= {lfsr[8:0], lfsr[9] ^ lfsr[6]};
	end

	assign prbs = lfsr;

endmodule