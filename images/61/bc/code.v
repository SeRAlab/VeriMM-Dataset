module top_module(
    input A,
    input B,
    input Ci,
    output S,
    output Co
);assign S = A ^ B ^ Ci;
    assign Co = (A & B) | (B & Ci) | (A & Ci);
endmodule