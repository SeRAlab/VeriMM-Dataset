module top_module(c, r, q, cout);input c, r;
	output [2:0] q;
	output reg cout;
	
	reg[2:0] ctval;
	assign q = ctval;
	always @(posedge c or posedge r) 
		if (r) 
			{cout, ctval} <= 0;
		else 
			{cout,ctval} <= ctval + 1'b1;
endmodule