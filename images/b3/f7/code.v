module top_module(
    A,
    B,
    SEL,
    Y,
    VPWR,
    VGND
);input A;
    input B;
    input SEL;
    output Y;
    input VPWR;
    input VGND;

    wire not_sel;
    wire and1_out;
    wire and2_out;

    // Using basic NOT and AND operations instead of specific library cells
    assign not_sel = ~SEL;           // Simple NOT gate
    assign and1_out = A & not_sel;   // AND gate for A and not_sel
    assign and2_out = B & SEL;       // AND gate for B and SEL

    assign Y = and1_out | and2_out;  // Output of the MUX

endmodule