module linear_regression (
    input [15:0] m, // slope
    input [15:0] b, // y-intercept
    input [15:0] x, // input value
    output reg [15:0] y // predicted output
);
    always @(*) begin
        y = (m * x) + b; // linear regression formula
    end
endmodule