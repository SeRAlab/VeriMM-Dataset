module top_module(
    input A0,
    input A1,
    input S,
    output Y,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);// Local signals
    wire not_S;
    wire A0_and_not_S;
    wire A1_and_S;
    wire Y_buf;

    // Invert S signal
    not #(1) not_S_inst (not_S, S);

    // AND A0 with not(S)
    and #(1) A0_and_not_S_inst (A0_and_not_S, A0, not_S);

    // AND A1 with S
    and #(1) A1_and_S_inst (A1_and_S, A1, S);

    // OR A0_and_not_S with A1_and_S
    or #(1) Y_buf_inst (Y_buf, A0_and_not_S, A1_and_S);

    // Buffer Y_buf to Y
    buf #(1) buf_inst (Y, Y_buf);

endmodule