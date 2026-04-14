module top_module(
    input A,
    input B,
    output Y
);wire w1;
    wire w2;

    assign w1 = A & B;
    assign w2 = w1;
    assign Y = w2;

endmodule