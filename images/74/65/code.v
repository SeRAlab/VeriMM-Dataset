module top_module (
	input w, 
	input x, 
	input y, 
	input z,
	output reg g);assign g = w&~x | y&~z | ~w&z;

endmodule