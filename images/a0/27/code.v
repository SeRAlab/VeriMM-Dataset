module top_module(
    input clk,
    input rst,
    input [31:0] A,
    input [31:0] B,
    output [31:0] Y
);wire [31:0] sum;

    assign sum = A + B;

    assign Y = rst ? 0 : sum;

endmodule