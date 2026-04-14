module top_module(
    // module ports
    input [3:0] D,
    input S0,
    input S1,
    output Y
);wire not_S1;
    wire not_S0;

    // invert S1 and S0 signals
    assign not_S1 = ~S1;
    assign not_S0 = ~S0;

    // select the correct input based on S1 and S0
    assign Y = (D[0] & not_S1 & not_S0) | (D[1] & not_S1 & S0) | (D[2] & S1 & not_S0) | (D[3] & S1 & S0);

endmodule