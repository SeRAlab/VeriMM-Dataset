module and_xor_module (
	input a, 
	input b, 
	output reg c);always @(*) 
	begin
		if (a && b) 
			c = a & b;
		else 
			c = a ^ b;
	end
	
endmodule