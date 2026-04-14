module top_module (
	input g,
	input h,
	input i,
	input j,
	output reg k);assign k = ((g & h) | i | j);
endmodule