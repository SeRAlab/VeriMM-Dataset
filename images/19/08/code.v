module vector_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] S
);
    assign S = A + B;
endmodule