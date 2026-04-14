module lfsr(
	input clk,
	input reset,
	output reg [31:0] q);
wire feedback = q[31] ^ q[21] ^ q[1] ^ q[0];

always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 32'h1; // Non-zero seed
	else
		q <= {q[30:0], feedback};
end

endmodule