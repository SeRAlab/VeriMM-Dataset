module top_module(
    output X,
    input  A,
    input  B,
    input  C,
    input  D
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire AB, CD;

    // Implement OR operation using combinational logic
    assign AB = A | B;
    assign CD = C | D;

    assign X = AB | CD;

endmodule