module top_module(
	input clk,
	input enable,
	input load,
	input dir,
	input reset,
	input [15:0] load_value,
	output reg [15:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 16'b0;
	else if (load)
		q <= load_value;
	else if (enable) begin
		if (dir)
			q <= {1'b0, q[15:1]};
		else
			q <= {q[14:0], 1'b0};
	end
end
endmodule