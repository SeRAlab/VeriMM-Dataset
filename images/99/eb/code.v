module top_module(
    Y ,
    A1,
    A2,
    B1
);output Y ;
    input  A1;
    input  A2;
    input  B1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;
    
    // Logic for determining Y
    assign Y = (A1) ? 1 : ((A2 & ~B1) | (~A2 & B1));

endmodule