module Adder64Bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] Sum,
    output Overflow
);
    assign {Overflow, Sum} = A + B;
endmodule