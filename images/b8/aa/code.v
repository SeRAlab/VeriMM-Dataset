module lfsr(
	input clk,
	output reg [6:0] q);
wire feedback = q[6] ^ q[5];
always @(posedge clk) begin
		q <= {q[5:0], feedback};
	end
endmodule