module binary_adder(
    input [3:0] A,
    input [3:0] B,
    input C,
    output [3:0] S
);

    assign S = A + B + C;

endmodule