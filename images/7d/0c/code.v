module top_module(
    input [7:0] a,
    input [7:0] b,
    output [15:0] result
);wire [7:0] sum;
    wire [15:0] square_sum;
    wire [15:0] product;

    assign sum = a + b;
    assign square_sum = sum * sum;
    assign product = a * b;

    assign result = square_sum + product;

endmodule