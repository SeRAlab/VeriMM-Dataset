module linear_regression (
    input [15:0] m,  // slope
    input [15:0] b,  // y-intercept
    input [15:0] x,  // input x value
    output reg [31:0] y // output y value
);

always @(*) begin
    y = (m * x) + b; // Calculate y = mx + b
end

endmodule