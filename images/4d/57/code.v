module or_and_module (
	input m, 
	input n, 
	output reg z);always @(*) 
	begin
		if (m && n) 
			z = m | n;
		else 
			z = m & n;
	end
	
endmodule