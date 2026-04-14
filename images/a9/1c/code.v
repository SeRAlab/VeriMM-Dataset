module or_gate(
    input [1:0] a,
    input [1:0] b,
    output [1:0] result
);
    assign result = a | b;
endmodule