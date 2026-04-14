module complement_module (
	input [3:0] u, 
	input v, 
	output reg [3:0] w);always @(*) 
	begin
		if (v) 
			w = ~u;
		else 
			w = u;
	end
	
endmodule