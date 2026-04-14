module linear_regression (
    input signed [15:0] x,
    output signed [15:0] y_estimated
);
    parameter signed [15:0] a = 2; // Example slope
    parameter signed [15:0] b = 3; // Example intercept

    assign y_estimated = (a * x) + b;
endmodule