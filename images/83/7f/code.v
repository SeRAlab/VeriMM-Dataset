module top_module(
    Z   ,
    A   ,
    TE_B
);output Z   ;
    input  A   ;
    input  TE_B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign Z = TE_B ? ~A : 0;

endmodule