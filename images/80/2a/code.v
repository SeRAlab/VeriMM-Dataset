module top_module(Qa, Qb, R, S, Clk);input R, S, Clk;
	output Qa, Qb;
	
	wire S_g, R_g;
	
	assign S_g = ~{S&Clk};
	assign R_g = ~{R&Clk};
	
	assign Qa = ~{Qb&S_g};
	assign Qb = ~{Qa&R_g};endmodule