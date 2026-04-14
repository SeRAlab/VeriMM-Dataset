module dff (
	input d, 
	input clk, 
	output reg q);always @(posedge clk)
	begin
		if (d) 
			q = d;
	end
	
endmodule