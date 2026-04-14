module bitwise_and(
    input [7:0] A,
    input [7:0] B,
    output [7:0] C
);

    assign C = A & B;

endmodule