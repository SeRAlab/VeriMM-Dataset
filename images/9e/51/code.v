module top_module(
    output X,
    input  A0,
    input  A1,
    input  S
);// Local signals
    wire mux_2to1_out_X;

    // 2-to-1 MUX Implementation
    assign mux_2to1_out_X = (S) ? A1 : A0;

    // Buffer output
    assign X = mux_2to1_out_X;

endmodule