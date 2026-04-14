module up_down_counter (
	input clk,
	input reset,
	input enable,
	input direction,
	output reg [3:0] count);

	always @(posedge clk) begin
		if (reset) begin
			count <= 4'b0000;
		end else if (enable) begin
			if (direction)
				count <= count + 1;
			else
				count <= count - 1;
		end
	end
	
endmodule