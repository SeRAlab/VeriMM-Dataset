module top_module(O, I0, I1, S);`ifdef XIL_TIMING

    parameter LOC = "UNPLACED";

`endif

    
    output O;
    input I0, I1, S;
    
    reg O_out;

    always @(I0 or I1 or S) 
        if (S)
	    O_out = I1;
	else
	    O_out = I0;
    
    assign O = O_out;
    
`ifdef XIL_TIMING

    specify
                                                                                 
        (I0 => O) = (0:0:0, 0:0:0);
        (I1 => O) = (0:0:0, 0:0:0);
	(S => O) = (0:0:0, 0:0:0);
        specparam PATHPULSE$ = 0;
                                                                                 
    endspecify

`endif
    
endmodule