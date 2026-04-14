module lfsr (
	input clk,
	output reg [7:0] count);

always @(posedge clk) begin
	count <= {count[6:0], count[7] ^ count[5] ^ count[4] ^ count[0]};
end

endmodule