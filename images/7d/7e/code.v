module top_module(
    X ,
    A1,
    A2,
    A3,
    B1
);output X ;
    input  A1;
    input  A2;
    input  A3;
    input  B1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire and1;
    wire and2;
    wire or1;

    assign and1 = A1 & A2;
    assign and2 = A2 & A3;
    assign or1 = and1 | and2;

    assign X = (B1) ? 1'b0 : or1;

endmodule