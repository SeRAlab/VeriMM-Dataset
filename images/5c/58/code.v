module top_module(
    input A,
    input B,
    input C,
    input D,
    output X,
    output Y
);assign X = A & B;
    assign Y = C | (B & D);

endmodule