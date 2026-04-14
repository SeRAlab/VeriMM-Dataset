module sum_three_inputs (
    input [4:0] A,
    input [4:0] B,
    input [4:0] C,
    output [5:0] SUM
);
    assign SUM = A + B + C;
endmodule