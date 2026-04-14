module eight_bit_adder (
    input [7:0] A,
    input [7:0] B,
    output [7:0] S,
    output Cout
);
    assign {Cout, S} = A + B;
endmodule