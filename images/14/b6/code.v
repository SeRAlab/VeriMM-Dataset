module adder_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] Sum,
    output CarryOut
);
    assign {CarryOut, Sum} = A + B;
endmodule