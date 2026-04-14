module top_module(O, I0);parameter INIT = 2'h0;

    input I0;

    output O;
    
    wire O;

    assign O = (INIT[0] == INIT[1]) ? INIT[0] : INIT[I0];endmodule