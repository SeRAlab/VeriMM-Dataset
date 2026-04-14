module top_module(
    Y,
    A1,
    A2,
    A3,
    B1,
    VPWR,
    VGND,
    VPB,
    VNB
);output Y;
    input A1, A2, A3, B1, VPWR, VGND, VPB, VNB;

    assign Y = A1 & A2 & A3 & B1;

endmodule