module top_module (
	input d, 
	input e, 
	input f, 
	output reg g);assign g = (d & ~e & f) | (~d & e & f) | (d & e & ~f);
	
endmodule