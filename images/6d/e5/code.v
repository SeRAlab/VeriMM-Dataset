module top_module (
	input u, 
	input v, 
	input w, 
	input x,
	output reg y);assign y = (u & v & w & x) | (u & ~v & w & ~x) | (~u & v & w & x) | (u & ~v & ~w & x);

endmodule