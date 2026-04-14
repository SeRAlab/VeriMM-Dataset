module top_module(
    input A,
    input B,
    input C_IN,
    output S,
    output C_OUT
);assign S = A ^ B ^ C_IN;           // Sum calculation
    assign C_OUT = (A & B) | (C_IN & (A ^ B)); // Carry-out calculation
endmodule