module top_module (
	input clk,
	input d,
	input en,
	output reg [2:0] t);always @(posedge clk)
	if (en) begin
		if (d)
			t <= 1;
		else if (t == 3)
			t <= 0;
		else
			t <= t + 1'b1;
	end

endmodule