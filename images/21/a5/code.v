module vector_adder(
    input [3:0] A,
    input [3:0] B,
    output [4:0] S,
    output overflow
);
    assign S = A + B;
    assign overflow = (S > 15) ? 1'b1 : 1'b0;
endmodule