module toggle_flipflop (
	input d, 
	input clk, 
	output reg q);always @(posedge clk)
	begin
		if (d) 
			q = ~q;
	end
	
endmodule