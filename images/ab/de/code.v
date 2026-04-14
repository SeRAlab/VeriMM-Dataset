module johnson_counter_with_enable (
	input clk,
	input reset,
	input enable,
	output reg [7:0] count);

	always @(posedge clk) begin
		if (reset) begin
			count <= 8'b00000000;
		end else if (enable) begin
			count <= {count[6:0], ~count[7]};
		end
	end
	
endmodule