module top_module(
	input clk, reset, enable,
	output delay_enable
);reg [19:0] count;
	always @(posedge clk) begin
		if (!reset)
			count <= 20'd833334;
		else if (enable) begin
			if (count == 20'd0)
				count <= 20'd833334;
			else
				count <= count - 1'b1;
		end
	end
		
	assign delay_enable = (count == 20'd0) ? 1 : 0;endmodule