module logic_gate (
    input A,
    input B,
    input C,
    input D,
    input E,
    output Y
);

    assign Y = (A & B) | (!C & D) | E;

endmodule