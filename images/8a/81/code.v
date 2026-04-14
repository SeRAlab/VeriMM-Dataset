module top_module(AddrB, clock, Reset,IncB);output reg[1:0] AddrB=-1;
	input clock;
	input IncB, Reset;


	always @ (Reset==1)
		AddrB<=0;

	always @ (posedge IncB)
		AddrB <= AddrB+1;endmodule