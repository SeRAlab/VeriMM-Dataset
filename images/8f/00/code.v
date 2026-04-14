module top_module(
    COUT,
    SUM ,
    A   ,
    B   ,
    CI
);output COUT;
    output SUM ;
    input  A   ;
    input  B   ;
    input  CI  ;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign {COUT, SUM} = A + B + CI;

endmodule