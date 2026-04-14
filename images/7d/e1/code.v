module top_module(
				out,
				sel,
				in0,
				in1
);parameter width = 8;
	
	output	wire	[width - 1 : 0]	out;
	input	wire					sel;
	input	wire	[width - 1 : 0]	in0;
	input	wire	[width - 1 : 0]	in1;
	
	assign	out	=	(sel == 2'h0)	?	in0	:	in1;
	
endmodule