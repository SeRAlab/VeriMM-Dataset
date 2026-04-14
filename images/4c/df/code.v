module top_module(
    A,
    B,
    C,
    D_N,
    VPWR,
    VGND,
    VPB,
    VNB,
    X
);// Module ports
    input A;
    input B;
    input C;
    input D_N;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;
    output X;

    // Local signals
    wire not1_out;
    wire or1_out;
    wire pwrgood_out;
    wire buf_out;

    // Not gate
    not not1 (not1_out, D_N);

    // OR gate
    or or1 (or1_out, A, B, C);

    // Power good output
    assign pwrgood_out = (VPWR == 1'b1 && VGND == 1'b0);

    // Buffer
    buf buf1 (buf_out, X, VPB, VNB);

    // Output
    assign X = ~or1_out;

endmodule