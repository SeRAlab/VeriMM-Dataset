module vector_adder (
    input [3:0] A,
    input [3:0] B,
    output [4:0] Sum,
    output Overflow
);
    assign Sum = A + B;
    assign Overflow = (Sum > 4'b1111) ? 1'b1 : 1'b0;
endmodule