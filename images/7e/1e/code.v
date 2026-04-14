module top_module(q,sel,w);input wire sel;
	input wire [0:1]w;
	output wire q;
	assign q=sel?w[1]:w[0];endmodule