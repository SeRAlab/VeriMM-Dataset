module top_module(
    Y ,
    A1,
    A2,
    A3,
    B1,
    B2
);output Y ;
    input  A1;
    input  A2;
    input  A3;
    input  B1;
    input  B2;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Implementing the logic
    assign Y = ((A1 & !A2 & !A3) | (B1 & B2) | (A1 & !A2 & A3) | (!A1 & A2 & A3)) ? 1 : 0;

endmodule