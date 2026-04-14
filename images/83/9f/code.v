module top_module(Sum, Carry, a, b);input a, b;
	output reg Sum;
	output Carry;
	
	always @(a or b) begin
		
		if(a != b)
			Sum = 1;
		else
			Sum = 0;
	
	end
	
	assign Carry = (a & b);
	
endmodule