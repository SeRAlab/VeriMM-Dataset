module top_module(Clk, D, Qa, Qb, Qc);input Clk, D;
	output reg Qa, Qb, Qc;
	
	
	always @( * )
		if (Clk == 1'b1)
			Qa <= D;
	
	
	always @(posedge Clk)
		Qb <= D;
	
	
	always @(negedge Clk)
		Qc <= D;
endmodule