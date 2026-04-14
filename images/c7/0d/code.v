module two_bit_comparator (
    input [1:0] A,
    input [1:0] B,
    output Y
);

    assign Y = (A > B) ? 1'b1 : 1'b0;

endmodule