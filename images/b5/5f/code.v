module top_module(LO, O, I0);parameter INIT = 2'h0;

    input I0;

    output LO, O;
    
    wire LO, O;

    assign O = (INIT[0] == INIT[1]) ? INIT[0] : INIT[I0];
    assign LO = O;endmodule