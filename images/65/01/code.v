module lfsr(
	input clk,
	input enable,
	input reset,
	output reg [15:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 16'b0000000000000001;
	else if (enable)
		q <= {q[14:0], q[15] ^ q[13] ^ q[12] ^ q[10]};
end
endmodule