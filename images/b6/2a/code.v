module d_flip_flop (
	input clock,
	input reset,
	input d,
	output reg q);always @(posedge clock or posedge reset) begin
		if (reset)
			q <= 0;
		else
			q <= d;
	end
	
	initial q = 0;
endmodule