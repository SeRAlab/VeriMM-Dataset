module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    output Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign Y = (A1 & A2 & A3 & ~B1);

endmodule