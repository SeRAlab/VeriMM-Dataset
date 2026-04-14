module comparator_4bit (
    input [3:0] a,
    input [3:0] b,
    output less,
    output equal,
    output greater
);

assign less = (a < b);
assign equal = (a == b);
assign greater = (a > b);

endmodule