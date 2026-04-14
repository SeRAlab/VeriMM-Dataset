module adder_subtractor (
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output [3:0] SUM
);

    wire [3:0] B_comp;
    assign B_comp = ~B + 1;

    assign SUM = (SUB) ? A + B_comp : A + B;

endmodule