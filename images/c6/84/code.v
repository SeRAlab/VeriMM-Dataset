module adder(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);

    assign {Cout, S} = A + B + Cin;

endmodule