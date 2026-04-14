module linear_regression (
    input [31:0] x1,
    input [31:0] x2,
    input [31:0] x3,
    input [31:0] x4,
    input [31:0] x5,
    input [31:0] w1,
    input [31:0] w2,
    input [31:0] w3,
    input [31:0] w4,
    input [31:0] w5,
    output [31:0] result
);
    wire [31:0] wx1, wx2, wx3, wx4, wx5;
    
    assign wx1 = w1 * x1;
    assign wx2 = w2 * x2;
    assign wx3 = w3 * x3;
    assign wx4 = w4 * x4;
    assign wx5 = w5 * x5;
    
    assign result = wx1 + wx2 + wx3 + wx4 + wx5;
endmodule