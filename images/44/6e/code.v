module top_module (
	input p, 
	input q, 
	input r, 
	output reg t);assign t = (p & ~q & r) | (~p & q & r) | (p & q & ~r);
	
endmodule