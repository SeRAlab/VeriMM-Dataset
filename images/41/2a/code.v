module logic_module (
	input a, 
	input b, 
	input c, 
	output reg z);always @(*) 
	begin
		if (c) 
			z = a & b;
		else 
			z = a | b;
	end
	
endmodule