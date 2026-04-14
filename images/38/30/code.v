module polynomial_evaluator (
    input [7:0] a0,
    input [7:0] a1,
    input [7:0] a2,
    input [7:0] a3,
    input [7:0] a4,
    input [3:0] x,
    output [15:0] result
);
    wire [15:0] x_squared;
    wire [15:0] x_cubed;
    wire [15:0] x_quad;

    assign x_squared = x * x;
    assign x_cubed = x_squared * x;
    assign x_quad = x_cubed * x;

    assign result = a0 + a1 * x + a2 * x_squared + a3 * x_cubed + a4 * x_quad;
endmodule