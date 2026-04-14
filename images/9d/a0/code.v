module top_module(
    X,
    A,
    B,
    C,
    D
);output X;
    input  A;
    input  B;
    input  C;
    input  D;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Internal wires
    wire AB;
    wire CD;
    wire ABCD;

    // Implement OR gate logic
    assign AB = A | B;
    assign CD = C | D;
    assign ABCD = AB | CD;
    assign X = ABCD;

endmodule