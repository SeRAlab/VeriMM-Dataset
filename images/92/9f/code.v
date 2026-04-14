module top_module(
	input clk,
	output [15:0] out);reg [15:0] lfsr;

	always @(posedge clk) begin
		lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
	end

	assign out = lfsr;

endmodule