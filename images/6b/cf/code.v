module top_module(
    input [3:0] A,
    input [3:0] B,
    input C_IN,
    output [3:0] S,
    output C_OUT
);wire [3:0] X;
    wire [3:0] Y;
    wire [3:0] Z;

    assign X = A ^ B;
    assign Y = A & B;
    assign Z = X & C_IN;

    assign S = X ^ C_IN;
    assign C_OUT = Y | Z;

endmodule