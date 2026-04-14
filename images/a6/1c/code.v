module top_module(a, b, carryin, carryout, sum);input a, b, carryin; 
	output carryout, sum; 
	
	assign carryout = (a && b) | (b && carryin) | (a && carryin);
	assign sum = a ^ b ^ carryin;endmodule