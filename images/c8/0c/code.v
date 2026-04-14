module adder_subtractor(
    input [3:0] A,
    input [3:0] B,
    input sub,
    output [3:0] result
);

wire [3:0] twos_complement;

assign twos_complement = ~B + 1;

assign result = sub ? A - B : A + B;

endmodule