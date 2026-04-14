module and_gate_extra(
    input A,
    input B,
    input C,
    output Y
);

    wire not_C;
    assign not_C = ~C;
    assign Y = A & B & not_C;

endmodule