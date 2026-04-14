module top_module(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);assign S = A ^ B ^ Cin;        // Sum output
    assign Cout = (A & B) | (B & Cin) | (A & Cin);  // Carry output
endmodule