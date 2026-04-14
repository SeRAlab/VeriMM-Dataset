module decoder3bit(
    input [2:0] a,
    output [7:0] y
);assign y = 1 << a;

endmodule