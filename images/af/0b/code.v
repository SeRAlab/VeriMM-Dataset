module top_module(gZero, pZero, cZero, gOne, pOne, gTwo, pTwo, cTwentyFour);input gZero, pZero, cZero, gOne, pOne, gTwo, pTwo;
	output cTwentyFour;
	
	assign cTwentyFour = gTwo | (pTwo & gOne) | (pTwo & pOne & gZero) | (pTwo & pOne & pZero & cZero);endmodule