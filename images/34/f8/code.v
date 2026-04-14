module comparator_32bit (
    input [31:0] A,
    input [31:0] B,
    output equal
);
    assign equal = (A == B);
endmodule