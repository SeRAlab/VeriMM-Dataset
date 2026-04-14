module binary_subtractor(
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output borrow_out
);
    assign {borrow_out, diff} = a - b;
endmodule