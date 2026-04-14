module top_module(
    Y,
    A0,
    A1,
    A2,
    A3,
    S0,
    S1
);// Module ports
    output Y;
    input A0;
    input A1;
    input A2;
    input A3;
    input S0;
    input S1;

    // Local signals
    wire mux_2to1_n0_out_Y;
    wire mux_2to1_n1_out_Y;
    wire mux_2to1_n2_out_Y;

    // Instantiate standard 2-to-1 multiplexers
    assign mux_2to1_n0_out_Y = S1 ? A1 : A0;
    assign mux_2to1_n1_out_Y = S1 ? A3 : A2;
    assign mux_2to1_n2_out_Y = S0 ? mux_2to1_n1_out_Y : mux_2to1_n0_out_Y;

    // Output buffer
    assign Y = mux_2to1_n2_out_Y;

endmodule