module linear_regression(
    input [15:0] x1,
    input [15:0] x2,
    input [15:0] w1,
    input [15:0] w2,
    input [15:0] b,
    output [31:0] y
);
    wire [31:0] wx1, wx2;

    assign wx1 = x1 * w1; // Calculate w1 * x1
    assign wx2 = x2 * w2; // Calculate w2 * x2
    assign y = wx1 + wx2 + b; // Calculate y = w1 * x1 + w2 * x2 + b
endmodule