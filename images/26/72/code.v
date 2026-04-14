module adder_8bit (
    input [7:0] A,
    input [7:0] B,
    output [7:0] Sum,
    output Carry
);
    assign {Carry, Sum} = A + B;
endmodule