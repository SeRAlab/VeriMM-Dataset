module top_module (
	input clk,
	input up_down, // 1 for up, 0 for down
	output reg [2:0] count);

	always @(posedge clk) begin
		if (up_down) begin
			count <= count + 1;
		end else begin
			count <= count - 1;
		end
	end
endmodule