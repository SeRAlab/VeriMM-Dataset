module top_module (
	input x, 
	input y, 
	input z, 
	input w,
	output reg m);assign m = x | ~y^z | ~x&~w;

endmodule