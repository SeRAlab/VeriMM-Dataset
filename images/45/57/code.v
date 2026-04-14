module top_module (
	input clk,
	input set,
	input d,
	output reg q);

	always @(posedge clk or posedge set) begin
		if (set)
			q <= 1;
		else
			q <= d;
	end
endmodule