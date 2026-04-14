module lfsr(
	input clk,
	input reset,
	output reg [15:0] lfsr);

always @(posedge clk) begin
	if (reset)
		lfsr <= 16'h1;
	else begin
		lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
	end
end

endmodule