module top_module(
    input A,
    input B,
    input CIN,
    output SUM,
    output COUT
);// Internal wires
    wire s1;
    wire c1;

    // Instantiate a behavioral description of a full adder
    assign SUM = A ^ B ^ CIN; // Sum calculation
    assign COUT = (A & B) | (CIN & (A ^ B)); // Carry-out calculation

endmodule