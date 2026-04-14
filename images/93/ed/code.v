module top_module(LO, I0);parameter INIT = 2'h0;

    input I0;

    output LO;
  
    wire LO;

    assign LO = (INIT[0] == INIT[1]) ? INIT[0] : INIT[I0];endmodule