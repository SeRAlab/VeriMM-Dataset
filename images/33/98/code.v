module bitwise_and_equal (
    input [7:0] A,
    input [7:0] B,
    output [7:0] C,
    output equal
);
    assign C = A & B;         // Bitwise AND operation
    assign equal = (A == B);  // Check for equality
endmodule