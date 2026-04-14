module top_module(
    input  A1,
    input  A2,
    input  B1,
    input  B2,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = (A1 & A2 & ~B1 & ~B2) | (~A1 & ~A2 & B1 & B2);

endmodule