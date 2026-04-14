module top_module(
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] S,
    output Cout
);assign {Cout, S} = A + B + Cin; // Simple 32-bit adder logic
endmodule