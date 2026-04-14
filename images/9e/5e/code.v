module top_module(
    input  A,
    input  B,
    output Y
);wire n1, n2, n3, n4;

    assign n1 = ~(A & B);
    assign n2 = ~(A | B);
    assign n3 = ~(n1 | n2);
    assign n4 = ~(n3);

    assign Y = n4;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

endmodule