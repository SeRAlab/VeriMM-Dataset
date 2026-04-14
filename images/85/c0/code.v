module comparator4bit (
    input [3:0] a,
    input [3:0] b,
    output gt
);assign gt = (a > b) ? 1'b1 : 1'b0;

endmodule