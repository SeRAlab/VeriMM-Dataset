module top_module (
	input e, 
	input f, 
	input g, 
	input h,
	output reg m);assign m = e&~f | g&~h | ~e&h;

endmodule