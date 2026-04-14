module top_module (
	input clk,
	output reg [3:0] lfsr);

	always @(posedge clk) begin
		lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
	end
endmodule