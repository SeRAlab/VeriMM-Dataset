module linear_regression (
    input [7:0] x1,
    input [7:0] x2,
    output [15:0] y
);
    // Fixed weights and bias
    parameter w1 = 2;
    parameter w2 = 3;
    parameter b = 1;
    
    assign y = (w1 * x1) + (w2 * x2) + b;
endmodule