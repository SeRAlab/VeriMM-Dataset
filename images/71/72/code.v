module comparator_4bit(
    input [3:0] a,
    input [3:0] b,
    output equal
);

    assign equal = (a == b);

endmodule