module top_module(
	input set,
	input reset,
	output reg q);always @(*) begin
		if (set)
			q <= 1'b1;
		else if (reset)
			q <= 1'b0;
	end
	
endmodule