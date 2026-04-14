module binary_to_gray(BIN, GRAY);
input [1:0] BIN;
output [3:0] GRAY;
reg [3:0] GRAY;

always@(BIN) begin
	GRAY[3] = BIN[1];
	GRAY[2] = BIN[1] ^ BIN[0];
	GRAY[1] = 0; // Unused in this 2-bit to 4-bit conversion
	GRAY[0] = 0; // Unused in this 2-bit to 4-bit conversion
end

endmodule