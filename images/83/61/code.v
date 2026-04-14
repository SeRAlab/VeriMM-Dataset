module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output Cout
);wire [3:0] C;

    assign S = A + B;
    assign C = (A + B) > 4'b1111;

    assign Cout = C[3];

endmodule