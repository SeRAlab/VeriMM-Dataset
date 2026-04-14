module top_module(output o, input i0, i1, r);wire c01, nr;

    // Inverter using continuous assignment
    assign nr = ~r;

    // AO222 gate
    assign c01 = (i0 & i1) | (i0 & i1) | (i1 & i1);

    // AND2 gate
    assign o = c01 & nr;

endmodule