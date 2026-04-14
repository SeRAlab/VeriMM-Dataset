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
    wire not_S0;
    wire not_S1;
    wire and_0_out;
    wire and_1_out;
    wire and_2_out;
    wire and_3_out;
    wire or_0_out;

    // Invert S0 and S1
    not not_S0_inst (not_S0, S0);
    not not_S1_inst (not_S1, S1);

    // AND gates
    and and_0_inst (and_0_out, A0, not_S0, not_S1);
    and and_1_inst (and_1_out, A1, not_S0, S1);
    and and_2_inst (and_2_out, A2, S0, not_S1);
    and and_3_inst (and_3_out, A3, S0, S1);

    // OR gate
    or or_0_inst (or_0_out, and_0_out, and_1_out, and_2_out, and_3_out);

    // Output
    assign Y = or_0_out;

endmodule