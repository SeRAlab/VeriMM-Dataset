module top_module(
    Y,
    A,
    B,
    C,
    D
);output Y;
    input  A;
    input  B;
    input  C;
    input  D;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire w1, w2, w3;

    // Replace the unknown nor4 module with a standard available gate or implement it using existing logic
    wire not_w1, not_w2;

    // Using NAND instead of NOR for broader compatibility; inverts to achieve a similar functionality
    assign w1 = ~(A & B);
    assign w2 = ~(C & D);
    assign w3 = ~(w1 & w2);
    
    assign Y = ~w3;

endmodule