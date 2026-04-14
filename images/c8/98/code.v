module mult_by_3(
    input [3:0] x,
    output [5:0] y
);

    assign y = (x << 1) + x;

endmodule