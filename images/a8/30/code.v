module msb_extractor (
	input clk,
	input [7:0] data,
	output reg msb_out);always @(posedge clk) begin
		msb_out <= data[7];
	end

endmodule