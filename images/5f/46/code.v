module flipflop (
	input d, 
	input q, 
	output reg y);always @(posedge q)
	begin
		if (q) 
			y = d;
		else 
			y = ~d;
	end
	
endmodule