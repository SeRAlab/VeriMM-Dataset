module gray_counter (
	input clk,
	input reset,
	output reg [4:0] gray);

	reg [4:0] bin;

	always @(posedge clk) begin
		if (reset) bin <= 5'b00000;
		else bin <= bin + 1;
	end

	always @(bin) begin
		gray = bin ^ (bin >> 1);
		end
endmodule