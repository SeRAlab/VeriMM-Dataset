module top_module(s, p, q, r, t);output s;
	input p, q, r, t;
	
	assign s = ~(((p^q)^r)^t);endmodule