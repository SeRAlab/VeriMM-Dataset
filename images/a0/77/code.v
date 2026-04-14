module top_module(
	input [31:0]sing_ext1,
	input [31:0]data0,
	input aluSRC,
	output [31:0]salida
	
);assign
	salida = (aluSRC)? sing_ext1 : data0;

endmodule