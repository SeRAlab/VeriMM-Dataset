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
    supply1 VPB;
    supply0 VNB;

    // Directly implementing the NOR operation using an assign statement
    assign Y = ~(A | B | C | D);

endmodule