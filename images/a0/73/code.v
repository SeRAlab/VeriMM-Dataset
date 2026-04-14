module top_module(
    input  A1,
    input  A2,
    input  B1,
    output Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Output logic
    assign Y = (A1 & A2) | B1;

endmodule