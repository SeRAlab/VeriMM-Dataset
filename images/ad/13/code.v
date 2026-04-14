module galois_lfsr (
	input clk,
	input rst,
	output reg [5:0] prbs);

	always @(posedge clk) begin
		if (rst)
			prbs <= 6'b111111;
		else
			prbs <= {prbs[4:0], prbs[5] ^ prbs[3]};
	end
	
endmodule