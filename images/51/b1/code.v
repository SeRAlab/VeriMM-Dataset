module binary_to_gray (
	input [4:0] binary,
	output reg [4:0] gray);
	
	always @(*) begin
		gray[4] = binary[4];
		gray[3] = binary[4] ^ binary[3];
		gray[2] = binary[3] ^ binary[2];
		gray[1] = binary[2] ^ binary[1];
		gray[0] = binary[1] ^ binary[0];
	end

endmodule