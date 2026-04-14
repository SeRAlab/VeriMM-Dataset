module top_module(
	input seletor,
	input [31:0] hiDiv,
	input [31:0] hiMult,
	output  [31:0] HI  
);assign HI = (seletor) ? hiMult : hiDiv;

endmodule