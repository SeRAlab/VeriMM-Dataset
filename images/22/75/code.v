module linear_regression (
    input [15:0] x,  // Independent variable
    input [15:0] m,  // Slope coefficient
    input [15:0] b,  // Intercept coefficient
    output reg [31:0] y // Dependent variable
);
    always @(*) begin
        y = (m * x) + b; // Calculate y = mx + b
    end
endmodule