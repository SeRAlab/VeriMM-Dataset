module top_module(LO, I0, I1, S);output LO;
    reg    LO;

    input  I0, I1, S;

	always @(I0 or I1 or S)
	    if (S)
		LO <= I1;
	    else
		LO <= I0;endmodule