module top_module(a, b, c, sum, carry);input a;         
	input b;         
	input c;         
	
	output sum;      
	output carry;    

	assign sum = a^b^c;
	assign carry = a&b | c&(a^b);endmodule