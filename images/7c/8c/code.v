module comparator (
    input [3:0] a,
    input [3:0] b,
    output greater
);

    assign greater = (a > b);

endmodule