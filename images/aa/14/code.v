module top_module (
	input clk,
	input reset_n,
	input shift,
	output reg [9:0] lfsr);always @(posedge clk) begin
	if (!reset_n)
		lfsr <= 10'b1;
	else if (shift)
		lfsr <= {lfsr[8:0], lfsr[9] ^ lfsr[6]};
end

endmodule