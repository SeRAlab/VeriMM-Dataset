module top_module(
    output [3:0] Y,
    input [3:0] A,
    input [3:0] B
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire [3:0] xor0, xor1, xor2, xor3;

    // First set of XOR operations
    xor x0 (xor0[0], A[0], B[0]);
    xor x1 (xor0[1], A[1], B[1]);
    xor x2 (xor0[2], A[2], B[2]);
    xor x3 (xor0[3], A[3], B[3]);

    // Second set of XOR operations
    xor x4 (xor1[0], xor0[0], xor0[1]);
    xor x5 (xor1[1], xor0[2], xor0[3]);
    xor x6 (xor2[0], xor1[0], xor1[1]);
    xor x7 (xor2[1], xor1[2], xor1[3]);

    // Third set of XOR operations
    xor x8 (xor3[0], A[0], B[0]);
    xor x9 (xor3[1], A[1], B[1]);
    xor x10 (xor3[2], A[2], B[2]);
    xor x11 (xor3[3], A[3], B[3]);

    xor x12 (xor2[2], xor3[0], xor3[1]);
    xor x13 (xor2[3], xor3[2], xor3[3]);

    assign Y = {xor2[3], xor2[2], xor2[1], xor2[0]};

endmodule