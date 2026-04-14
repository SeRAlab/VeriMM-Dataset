module eight_bit_adder (
    input [7:0] A,
    input [7:0] B,
    output [7:0] SUM,
    output COUT
);
    assign {COUT, SUM} = A + B;
endmodule