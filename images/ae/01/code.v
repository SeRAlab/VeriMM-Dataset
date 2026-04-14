module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    output [3:0] S,
    output Cout
);wire [3:0] sum;
    wire carry;

    assign sum = A + B + C;
    assign Cout = (sum > 4'b1111) ? 1'b1 : 1'b0;
    assign S = sum;

endmodule