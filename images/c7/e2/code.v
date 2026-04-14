module logic_gate (
    input A,
    input B,
    input C,
    output Y
);

    assign Y = (~A & 1'b0) | (A & ~B) | (A & B & C);

endmodule