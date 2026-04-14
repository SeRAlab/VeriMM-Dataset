module top_module(O, CI, DI, S);`ifdef XIL_TIMING

    parameter LOC = "UNPLACED";

`endif


    output O;
    input CI, DI, S;
    
    reg O_out;

	always @(CI or DI or S) 
	    if (S)
		O_out = CI;
	    else
		O_out = DI;

    assign O = O_out;
    
`ifdef XIL_TIMING

    specify
                                                                                 
        (CI => O) = (0:0:0, 0:0:0);
        (DI => O) = (0:0:0, 0:0:0);
	(S => O) = (0:0:0, 0:0:0);
        specparam PATHPULSE$ = 0;
                                                                                 
    endspecify

`endif

endmodule