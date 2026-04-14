module sky130_fd_sc_hvl__lsbufhv2hv_lh (
    X,
    A
);

    output X;
    input  A;

    // Voltage supply signals
    supply1 VPWR    ;
    supply0 VGND    ;
    supply1 LOWHVPWR;
    supply1 VPB     ;
    supply0 VNB     ;

    assign X = A ? VPB : VNB;

endmodule