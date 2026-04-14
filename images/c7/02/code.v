module nand_gate (
    Y,
    A,
    B
);

    output Y;
    input  A;
    input  B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign Y = ~(A & B);

endmodule