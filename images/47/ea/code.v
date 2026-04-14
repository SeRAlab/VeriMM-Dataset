module top_module(
    input A,
    input B,
    input S,
    output Y
);assign Y = (S == 1'b1) ? B : A;

endmodule