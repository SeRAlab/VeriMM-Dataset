module Adder32Bit (
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] S,
    output Cout
);
    assign {Cout, S} = A + B + Cin; // Perform addition and include carry-in
endmodule