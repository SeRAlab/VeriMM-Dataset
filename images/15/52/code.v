module two_bit_adder (
    input [1:0] A,
    input [1:0] B,
    output [2:0] SUM,
    output COUT
);
    assign {COUT, SUM} = A + B;
endmodule