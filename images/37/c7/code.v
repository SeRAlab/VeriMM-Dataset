module two_bit_adder (
    input [1:0] A,
    input [1:0] B,
    output [2:0] SUM
);
    assign SUM = A + B;
endmodule