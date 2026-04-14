module linear_regression (
    input [15:0] x,     // Input value x
    input [15:0] m,     // Slope m
    output reg [31:0] y_prime // Output computed value y'
);
    parameter b = 16; // constant intercept

    always @(*) begin
        // y' = m*x + b
        y_prime = (m * x) + b;
    end
endmodule