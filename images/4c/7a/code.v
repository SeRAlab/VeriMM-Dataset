module xor_and_module (
	input a, 
	input b, 
	output reg y);always @(*) 
	begin
		if (a && b) 
			y = a ^ b;
		else 
			y = a & ~b;
	end
	
endmodule