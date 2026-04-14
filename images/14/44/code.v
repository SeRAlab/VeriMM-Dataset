module logistic_regression (
    input wire x1,
    input wire x2,
    output wire y
);
    wire [3:0] z; // z = w1*x1 + w2*x2 + b
    assign z = (1 * x1) + (1 * x2) - 1; // w1 = 1, w2 = 1, b = -1
    assign y = (z > 0) ? 1 : 0; // logistic function output
endmodule