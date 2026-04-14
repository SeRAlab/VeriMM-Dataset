module linear_regression (
    input [15:0] x1,
    input [15:0] x2,
    output reg [15:0] y
);
    parameter signed [15:0] m1 = 3; // Coefficient for x1
    parameter signed [15:0] m2 = 5; // Coefficient for x2
    parameter signed [15:0] b = 2;   // Intercept

    always @(*) begin
        y = m1 * x1 + m2 * x2 + b;
    end
endmodule