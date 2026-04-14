module linear_regression (
    input signed [15:0] m, // slope
    input signed [15:0] b, // intercept
    input signed [15:0] x, // input value
    output signed [31:0] y // output value
);
    assign y = (m * x) + b;
endmodule