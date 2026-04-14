module up_down_counter (
	input clk,
	input reset,
	input direction,
	output reg [15:0] count);

	always @(posedge clk) begin
		if (reset)
			count <= 16'h0000;
		else if (direction)
			count <= count + 1;
		else
			count <= count - 1;
	end
	
endmodule