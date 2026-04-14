module top_module(
	input clk,
	input reset_n,
	output reg [4:0] count);always @(posedge clk) begin
		if (!reset_n)
			count <= 5'b00001;
		else
			count <= {count[3:0], count[4]};
	end

endmodule