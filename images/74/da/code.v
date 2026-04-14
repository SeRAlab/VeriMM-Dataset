module top_module (
	input f,
	input g,
	input h,
	input i,
	output j);
assign j = (~(f | g | h)) & i;
endmodule