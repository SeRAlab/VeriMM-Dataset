module top_module(gZero, pZero, cZero, cEight);input gZero, pZero, cZero;
	output cEight;
	
	assign cEight = gZero | (pZero & cZero);endmodule