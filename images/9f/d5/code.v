module top_module(CLK,SET,TOG,Q);input CLK,SET,TOG;
	output reg Q;
	
	always @(negedge CLK)
		if (SET)
			Q=1'b1;
		else if (TOG)
			Q=~Q;
		else
			Q=Q;

endmodule