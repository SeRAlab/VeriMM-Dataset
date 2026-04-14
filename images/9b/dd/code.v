module top_module (
	input e, 
	input f, 
	input g, 
	input h,
	output reg p);assign p = e | ~f^g | ~e&~h;

endmodule