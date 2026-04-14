module subtractor(
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output borrow_out
);
    wire b1, b2, b3;

    full_subtractor fs0 (.a(a[0]), .b(b[0]), .bin(1'b0), .diff(diff[0]), .bout(b1));
    full_subtractor fs1 (.a(a[1]), .b(b[1]), .bin(b1), .diff(diff[1]), .bout(b2));
    full_subtractor fs2 (.a(a[2]), .b(b[2]), .bin(b2), .diff(diff[2]), .bout(b3));
    full_subtractor fs3 (.a(a[3]), .b(b[3]), .bin(b3), .diff(diff[3]), .bout(borrow_out));
endmodule

module full_subtractor(
    input a,
    input b,
    input bin,
    output diff,
    output bout
);
    assign {bout, diff} = a - b - bin;
endmodule