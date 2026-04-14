module top_module(
    input A,
    input B,
    output Y
);wire notA, notB, nor_out;

    // Implementing NOT using NOR gate
    assign notA = ~(A | A); // Equivalent to NOT A
    assign notB = ~(B | B); // Equivalent to NOT B

    // Implementing AND using NOR gates
    assign nor_out = ~(notA | notB); // NOR of notA and notB
    assign Y = nor_out; // Output Y is connected to the NOR gate result

endmodule