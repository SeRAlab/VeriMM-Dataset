module logistic_regression (
    input wire x1,
    input wire x2,
    input wire x3,
    input wire x4,
    input wire x5,
    output wire y
);

    wire [2:0] sum; // 3 bits to hold the sum

    assign sum = x1 + x2 + x3; // sum = w1*x1 + w2*x2 + w3*x3 + w4*x4 + w5*x5
    assign y = (sum >= 3) ? 1'b1 : 1'b0; // threshold = 2

endmodule