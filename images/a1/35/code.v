module top_module (
	input i,
	input j,
	input k,
	output reg l);assign l = (~(i | j)) ^ k;
endmodule