module polynomial_evaluator(
    input [3:0] a4,
    input [3:0] a3,
    input [3:0] a2,
    input [3:0] a1,
    input [3:0] a0,
    input [3:0] x,
    output [15:0] result
);
    wire [15:0] x2, x3, x4;
    
    assign x2 = x * x;
    assign x3 = x2 * x;
    assign x4 = x3 * x;
    
    assign result = a4 * x4 + a3 * x3 + a2 * x2 + a1 * x + a0;
endmodule