module top_module(i0, i1, sel, out	);parameter SIZE = 1;
  
	input  [SIZE-1:0] i0;
	input  [SIZE-1:0] i1;
	input             sel;
	output [SIZE-1:0] out;	
  
	assign out = (sel ? i1 : i0);endmodule