module top_module(input wire p2,g2,p1,g1,output wire p,g);assign p=p1&p2;
	assign g=g2 | (p2&g1);endmodule