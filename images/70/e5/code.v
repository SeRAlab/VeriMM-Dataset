module top_module(
    input A,
    input B,
    input C,
    output X,
    output Y
);assign X = A ? 1 : 0;
    assign Y = A ? (B & C) : (B | C);

endmodule