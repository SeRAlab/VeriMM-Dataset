module top_module(
    input  A1,
    input  A2,
    output Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // AND gate logic
    assign Y = A1 & A2;

endmodule