module linear_regression (
    input signed [7:0] x1,
    input signed [7:0] x2,
    input signed [7:0] b,
    output signed [15:0] y
);
    parameter signed [7:0] w1 = 8'd2; // Weight for x1
    parameter signed [7:0] w2 = 8'd3; // Weight for x2

    assign y = (w1 * x1) + (w2 * x2) + b;

endmodule