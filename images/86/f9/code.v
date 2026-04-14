module top_module(
    X ,
    A1,
    A2,
    B1,
    C1,
    D1
);output X ;
    input  A1;
    input  A2;
    input  B1;
    input  C1;
    input  D1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = (A1 & A2) | (B1 & ~C1);

    assign X = (D1 == 1'b1) ? 1'b0 : X;

endmodule