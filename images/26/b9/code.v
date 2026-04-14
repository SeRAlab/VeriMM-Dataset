module linear_regression (
    input [7:0] x1,
    input [7:0] y1,
    input [7:0] x2,
    input [7:0] y2,
    output reg signed [15:0] m,
    output reg signed [15:0] b
);

always @(*) begin
    // Calculate the slope m = (y2 - y1) / (x2 - x1)
    if (x2 != x1) begin
        m = (y2 - y1) * 100 / (x2 - x1); // Scale by 100 for integer division
    end else begin
        m = 0; // Vertical line case (undefined slope)
    end

    // Calculate the y-intercept b = y1 - m * x1
    b = y1 - (m * x1 / 100);
end

endmodule