module linear_regression (
    input signed [7:0] slope,
    input signed [7:0] intercept,
    input signed [7:0] x,
    output signed [15:0] y
);
    assign y = (slope * x) + intercept;
endmodule