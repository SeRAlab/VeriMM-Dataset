module top_module(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);assign S = A ^ B ^ Cin;  // Sum is the XOR of A, B, and Cin
    assign Cout = (A & B) | (Cin & (A ^ B)); // Cout is high if any two inputs are high
endmodule