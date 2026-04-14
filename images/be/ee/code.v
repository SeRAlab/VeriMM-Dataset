module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);wire AB, CD;

    // First level of OR gates
    assign AB = A | B; // Implementing the first OR gate
    assign CD = C | D; // Implementing the second OR gate

    // Second level of OR gate
    assign Y = AB | CD; // Final OR combining the two results

endmodule