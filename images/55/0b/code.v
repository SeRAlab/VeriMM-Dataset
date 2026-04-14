module top_module(A, B, C_N, VPWR, VGND, VPB, VNB, X);input A;
    input B;
    input C_N;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;
    output X;

    wire [2:0] or3;
    wire [2:0] inv;

    assign or3[0] = A | B | C_N;
    assign or3[1] = VPWR | VGND | VPB;
    assign or3[2] = VPWR | VGND | VNB;

    assign inv[0] = ~or3[0];
    assign inv[1] = ~or3[1];
    assign inv[2] = ~or3[2];

    assign X = ~(inv[0] & inv[1] & inv[2]);

endmodule