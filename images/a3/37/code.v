module fibonacci_lfsr (
	input clk,
	input rst,
	output reg [2:0] lfsr);

	always @(posedge clk) begin
		if (rst)
			lfsr <= 3'b001;
		else
			lfsr <= {lfsr[1], lfsr[0], lfsr[2] ^ lfsr[0]};
	end
	
endmodule