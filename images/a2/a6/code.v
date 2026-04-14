module top_module(
    input A,
    input B,
    output Sum,
    output Cout
);assign Sum = A ^ B;  // Sum is A XOR B
    assign Cout = A & B; // Cout is A AND B
endmodule