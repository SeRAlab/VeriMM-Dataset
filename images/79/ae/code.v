module top_module(a, b, ci, s, co);input wire a,b,ci;
	output wire s,co;
	and (c1,a,b), (c2,b,ci), (c3,a,ci);
	xor (s1,a,b), (s,s1,ci);
	or (co,c1,c2,c3);

endmodule