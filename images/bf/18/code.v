module top_module(
    COUT,
    SUM,
    A,
    B,
    CIN,
    VPWR,
    VGND,
    VPB,
    VNB
);// Module ports
output COUT;
output SUM;
input  A;
input  B;
input  CIN;
input  VPWR;
input  VGND;
input  VPB;
input  VNB;

// Local signals
wire ci;
wire xor0_out_SUM;
wire a_b;
wire a_ci;
wire b_ci;
wire or0_out_COUT;

// Inverted carry
not not0 (ci, CIN);

// Sum calculation
xor xor0 (xor0_out_SUM, A, B, ci);
buf buf0 (SUM, xor0_out_SUM);

// Carry-out calculation
and and0 (a_b, A, B);
and and1 (a_ci, A, ci);
and and2 (b_ci, B, ci);
or or0 (or0_out_COUT, a_b, a_ci, b_ci);

// Carry-out assignment
buf buf1 (COUT, or0_out_COUT);

endmodule