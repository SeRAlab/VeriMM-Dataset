module linear_regression (
    input [15:0] x,     // Input variable
    input [15:0] m,     // Slope
    input [15:0] b,     // Y-intercept
    output reg [31:0] y // Output variable
);
    always @(*) begin
        y = (m * x) + b; // Calculate y using the linear equation
    end
endmodule