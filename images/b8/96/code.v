module top_module(
    output X,
    input A0,
    input A1,
    input A2,
    input A3,
    input S0,
    input S1
);// Logic for 4-to-1 multiplexer
    wire mux_4to1_out;

    assign mux_4to1_out = (S1 == 0 && S0 == 0) ? A0 :
                           (S1 == 0 && S0 == 1) ? A1 :
                           (S1 == 1 && S0 == 0) ? A2 :
                           (S1 == 1 && S0 == 1) ? A3 : 1'bx;

    // Assign the output of the multiplexer
    assign X = mux_4to1_out;

endmodule