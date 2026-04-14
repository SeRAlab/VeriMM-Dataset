module six_input_one_output (
    input  A1,
    input  A2,
    input  B1,
    input  B2,
    input  C1,
    input  C2,
    output Y
);

    assign Y = (A1 & A2) | (B1 & B2) | (C1 & C2);

endmodule