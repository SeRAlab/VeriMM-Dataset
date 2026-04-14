module comparator_8bit(
    input [7:0] a,
    input [7:0] b,
    output gt
);

    assign gt = (a > b);

endmodule