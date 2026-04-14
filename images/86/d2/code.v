module comparator (
    input [1:0] a,
    input [1:0] b,
    output equal
);

assign equal = (a == b);

endmodule