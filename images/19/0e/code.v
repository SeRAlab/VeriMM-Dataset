module wallace_tree_adder (
    input [7:0] A,
    input [7:0] B,
    output [15:0] SUM
);
    assign SUM = A + B;
endmodule