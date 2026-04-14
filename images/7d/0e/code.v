module top_module (
	input clk,
	input reset_n,
	input s_in,
	output reg [7:0] q);always @(posedge clk, negedge reset_n) begin
		if (!reset_n)
			q <= 8'b00000000;
		else
			q <= {q[6:0], s_in};
	end
	
endmodule