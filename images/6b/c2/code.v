module top_module(
    output X,
    input  A,
    input  B,
    input  C,
    input  D
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire AB, CD, ABCD;

    // Modified to use a simple XOR operation instead
    assign AB = A ^ B;
    assign CD = C ^ D;
    assign ABCD = AB ^ CD;

    assign X = ABCD;

endmodule