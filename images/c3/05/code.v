module three_input_gate (
    input  A1,
    input  A2,
    input  B1,
    output Y
);

    assign Y = (A1 & A2) | B1;

endmodule