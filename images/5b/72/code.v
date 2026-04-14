module top_module(D, VPWR, VGND, VPB, VNB, Q);input D, VPWR, VGND, VPB, VNB;
    output Q;

    wire A, B, C, D_not, VPWR_not, VGND_not, VPB_not, VNB_not;

    assign D_not = ~D;
    assign VPWR_not = ~VPWR;
    assign VGND_not = ~VGND;
    assign VPB_not = ~VPB;
    assign VNB_not = ~VNB;

    assign A = D_not & VPWR_not & VGND_not & VPB_not & VNB_not;
    assign B = D_not & VPWR_not & VGND_not & VPB_not & VNB;
    assign C = D_not & VPWR_not & VGND_not & VPB & VNB_not;

    assign Q = (A | B) & C;

endmodule