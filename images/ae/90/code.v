module top_module(
    input a, b, c,
    input [1:0] ctrl,
    output w, x, y, z
);wire not_ctrl0, not_ctrl1;
    wire and_a, and_b, and_c, and_not_ctrl0, and_not_ctrl1;

    // Invert control signals
    assign not_ctrl0 = ~ctrl[0];
    assign not_ctrl1 = ~ctrl[1];

    // AND gates for each input and control signal combination
    assign and_a = a & not_ctrl0 & not_ctrl1;
    assign and_b = b & ctrl[0] & not_ctrl1;
    assign and_c = c & not_ctrl0 & ctrl[1];

    // AND gates for each input and inverted control signal combination
    assign and_not_ctrl0 = a & ctrl[0] & ctrl[1];
    assign and_not_ctrl1 = b & not_ctrl0 & ctrl[1];

    // Output the selected input on all four outputs
    assign w = and_a | and_b | and_c | and_not_ctrl0;
    assign x = and_a | and_b | and_not_ctrl1 | and_c;
    assign y = and_a | and_not_ctrl0 | and_not_ctrl1 | and_c;
    assign z = and_b | and_not_ctrl0 | and_not_ctrl1 | and_c;

endmodule