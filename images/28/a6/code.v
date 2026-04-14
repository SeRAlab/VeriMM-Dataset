module vector_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] SUM,
    output COUT
);
    assign {COUT, SUM} = A + B;
endmodule