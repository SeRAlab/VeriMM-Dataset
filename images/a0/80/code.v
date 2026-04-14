module binary_adder (
    input [1:0] A,
    input [1:0] B,
    output [1:0] Sum,
    output Cout
);

assign {Cout, Sum} = A + B;

endmodule