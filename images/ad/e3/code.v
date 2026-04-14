module top_module (
	input [3:0] binary,
	output reg [7:0] bcd);

integer i;

always @(*) begin
	bcd = 8'b0;
	for (i = 3; i >= 0; i = i - 1) begin
		bcd = {bcd[6:0], binary[i]};
		if (bcd[3:0] > 4)
			bcd[3:0] = bcd[3:0] + 3;
		if (bcd[7:4] > 4)
			bcd[7:4] = bcd[7:4] + 3;
	end
end

endmodule