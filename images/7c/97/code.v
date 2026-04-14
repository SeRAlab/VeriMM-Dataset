module top_module(
				out,
				sel,
				in0,
				in1,
				in2,
				in3
);parameter width = 8;
	
	output	wire	[width - 1 : 0]	out;
	input	wire	[1:0]			sel;
	input	wire	[width - 1 : 0]	in0;
	input	wire	[width - 1 : 0]	in1;
	input	wire	[width - 1 : 0]	in2;
	input	wire	[width - 1 : 0]	in3;
	
	assign	out	=	(sel == 2'h0)	?	in0	:
					(sel == 2'h1)	?	in1	:
					(sel == 2'h2)	?	in2	:	in3;
					
endmodule