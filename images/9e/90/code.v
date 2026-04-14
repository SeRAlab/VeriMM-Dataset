module top_module(
    Y,
    A1,
    A2,
    B1,
    C1,
    VPWR,
    VGND,
    VPB,
    VNB
);output Y;
    input A1;
    input A2;
    input B1;
    input C1;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    wire internal_signal_1;
    wire internal_signal_2;
    wire internal_signal_3;

    and #(1) and_gate_1 (
        internal_signal_1,
        A1,
        A2
    );

    and #(1) and_gate_2 (
        internal_signal_2,
        B1,
        C1
    );

    or #(1) or_gate_1 (
        internal_signal_3,
        internal_signal_1,
        internal_signal_2
    );

    assign Y = internal_signal_3;

endmodule