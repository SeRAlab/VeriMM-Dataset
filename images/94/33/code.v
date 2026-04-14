module top_module(
	input clk,
	output [5:0] out);reg [5:0] lfsr = 6'b000001;

	always @(posedge clk) begin
		lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[4]};
	end

	assign out = lfsr;

endmodule