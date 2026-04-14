module up_down_counter (
	input clk,
	input reset,
	input enable,
	output reg [3:0] count);

	always @(posedge clk) begin
		if (reset)
			count <= 4'b0000;
		else if (enable)
			count <= count + 1;
		else
			count <= count - 1;
	end
	
endmodule