module top_module(
    X,
    A0,
    A1,
    A2,
    A3,
    S0,
    S1,
    VPWR,
    VGND,
    VPB,
    VNB
);// Module ports
    output X;
    input A0;
    input A1;
    input A2;
    input A3;
    input S0;
    input S1;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    // Local signals
    wire sel_0;
    wire sel_1;
    wire not_sel_0;
    wire not_sel_1;
    wire and_0;
    wire and_1;
    wire and_2;
    wire and_3;
    wire or_0;

    // Invert select signals
    assign not_sel_0 = ~S0;
    assign not_sel_1 = ~S1;

    // Generate select signals for AND gates
    assign sel_0 = S0 & not_sel_1;
    assign sel_1 = not_sel_0 & S1;

    // Generate AND gates
    assign and_0 = A0 & sel_0 & sel_1;
    assign and_1 = A1 & not_sel_0 & sel_1;
    assign and_2 = A2 & sel_0 & not_sel_1;
    assign and_3 = A3 & not_sel_0 & not_sel_1;

    // Generate OR gate
    assign or_0 = and_0 | and_1 | and_2 | and_3;

    // Assign output
    assign X = or_0;

endmodule