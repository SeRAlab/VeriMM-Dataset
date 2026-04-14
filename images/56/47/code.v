module top_module(
    X,
    A
);output X;
    input  A;

    // Voltage supply signals
    supply1 VPWR    ;
    supply0 VGND    ;
    supply1 LOWHVPWR;
    supply1 VPB     ;
    supply0 VNB     ;

    assign X = A ? VPB : VNB;

endmodule