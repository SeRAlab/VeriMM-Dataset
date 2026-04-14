module lfsr(
	input clk,
	input reset,
	output reg [9:0] prng);

always @(posedge clk or posedge reset)
	if (reset)
		prng <= 10'b1;
	else
		prng <= {prng[8:0], prng[9] ^ prng[6]};

endmodule