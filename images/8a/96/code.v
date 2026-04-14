module adder_subtractor (
    input [3:0] a,
    input [3:0] b,
    input add_sub,
    output [3:0] result
);
    assign result = add_sub ? (a + b) : (a - b);
endmodule