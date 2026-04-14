module four_bit_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] Sum,
    output CarryOut
);
    assign {CarryOut, Sum} = A + B;
endmodule