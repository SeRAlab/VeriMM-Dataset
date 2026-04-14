module top_module(T, Clock, Resetn, Q);input T, Clock, Resetn;
	output reg Q;
	
	always @(posedge Clock)
		if (Resetn  == 1'b0)	
			Q <= 1'b0;
		else if(T)
			Q <= ~Q;endmodule