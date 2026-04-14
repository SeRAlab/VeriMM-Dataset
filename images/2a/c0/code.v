module linear_regression (
    input wire [15:0] x,  // 16-bit input for x
    output wire [15:0] y_pred // 16-bit output for predicted y'
);
    parameter signed [15:0] m = 16'sd2; // Example slope
    parameter signed [15:0] b = 16'sd3; // Example intercept

    assign y_pred = (m * x) + b; // Linear regression equation

endmodule