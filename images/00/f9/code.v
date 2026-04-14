module linear_regression (
    input signed [15:0] x,
    input signed [15:0] slope,
    input signed [15:0] intercept,
    output signed [31:0] y
);
    assign y = (slope * x) + intercept;
endmodule