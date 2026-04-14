module top_module(
    input [3:0] A, B,
    input Cin,
    output [3:0] C,
    output Cout
);assign {Cout, C} = A + B + Cin;

endmodule