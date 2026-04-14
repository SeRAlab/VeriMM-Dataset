module four_bit_adder(
    input [3:0] A, B,
    input Cin,
    output [3:0] C,
    output Cout
);

assign {Cout, C} = A + B + Cin;

endmodule