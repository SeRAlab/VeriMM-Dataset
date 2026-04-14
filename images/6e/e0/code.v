module and_operation(
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] result
);

    assign result = a & b;

endmodule