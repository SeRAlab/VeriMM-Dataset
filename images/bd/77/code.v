module top_module(
    input A,
    input B,
    input VPWR,
    input VGND,
    output SUM,
    output COUT
);// Instantiate a half-adder module or provide logic for half-adder functionality
    assign SUM = A ^ B;     // Sum is the XOR of A and B
    assign COUT = A & B;    // Carry out is the AND of A and B

endmodule