module top_module (
	input p, 
	input q, 
	input r, 
	output reg u);assign u = (p & ~q & r) | (~p & q & r) | (p & q & ~r);
	
endmodule