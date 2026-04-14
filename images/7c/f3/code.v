module top_module(
	input clk,
	output [7:0] prbs);reg [7:0] lfsr = 8'b00000001;

	always @(posedge clk) begin
		lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
	end

	assign prbs = lfsr;

endmodule