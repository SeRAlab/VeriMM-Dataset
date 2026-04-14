module linear_regression (
    input [3:0] x1,
    input [3:0] x2,
    output [4:0] y
);

assign y = 3 * x1 + 2 * x2 + 1;

endmodule