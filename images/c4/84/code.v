module adder_subtractor(
    input [7:0] A,
    input [7:0] B,
    input mode,
    output [7:0] result
);

    wire [7:0] twos_comp_B;
    wire [7:0] sum;

    assign twos_comp_B = ~B + 1;

    assign sum = A + (mode ? twos_comp_B : B);

    assign result = sum;

endmodule