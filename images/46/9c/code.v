module top_module (
	input [2:0] binary,
	output reg [2:0] gray);always_comb begin
		gray[2] = binary[2];
		gray[1] = binary[2] ^ binary[1];
		gray[0] = binary[1] ^ binary[0];
	end

endmodule