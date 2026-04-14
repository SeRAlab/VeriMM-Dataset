module two_bit_adder (
    input [1:0] A,
    input [1:0] B,
    output [1:0] Sum,
    output Carry
);
    assign {Carry, Sum} = A + B;
endmodule