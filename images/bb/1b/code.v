module top_module(
    Y ,
    A1,
    A2,
    B1,
    C1,
    D1
);output Y ;
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

    assign Y = (A1 & A2 & B1) | (!C1 & !D1);

endmodule