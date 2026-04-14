module combinational_circuit(
    input A,
    input B,
    output Y
);

assign Y = (A & ~B) | (~A & B);

endmodule