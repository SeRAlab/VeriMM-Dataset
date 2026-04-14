module comparator (
    input [3:0] A,
    input [3:0] B,
    output greater,
    output less
);

assign greater = (A > B);
assign less = (A < B);

endmodule