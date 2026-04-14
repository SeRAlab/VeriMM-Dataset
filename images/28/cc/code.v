module power_gating(
    input A,
    input B,
    input P,
    output Y
);
    assign Y = P ? (A & B) : 0;
endmodule