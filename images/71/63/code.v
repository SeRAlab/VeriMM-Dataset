module up_down_counter (
	input clk,
	input enable,
	input up_down,
	output reg [11:0] count);
	
	always @(posedge clk) begin
		if (enable) begin
			if (up_down)
				count <= count + 1;
			else
				count <= count - 1;
		end
	end

endmodule