module top_module(AddrA, clock, Reset, IncA);output reg[2:0] AddrA;
	input clock;
	input Reset;
	input IncA;

	always @ (Reset==1)
		AddrA<=-1;

	always @ (posedge clock && IncA==1)
		AddrA <= AddrA+1;endmodule