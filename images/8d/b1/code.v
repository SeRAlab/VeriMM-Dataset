module top_module(
    output S,     // Sum output
    output Cout,  // Carry output
    input A,      // First input
    input B,      // Second input
    input Cin     // Carry input
);assign S = A ^ B ^ Cin;        // Sum calculation
    assign Cout = (A & B) | (Cin & (A ^ B)); // Carry calculation
endmodule