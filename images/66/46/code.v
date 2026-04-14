module top_module(
	input clk,
	input reset,
	input [11:0] data,
	output reg [11:0] crc);always @(posedge clk) begin
		if (reset)
			crc <= 12'b000000000000;
		else
			crc <= {data[11:1], data[11] ^ data[1] ^ data[0], data[10:2]};
	end
endmodule