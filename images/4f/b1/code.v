module comparator_8bit(
    input wire [7:0] a,
    input wire [7:0] b,
    output wire eq,
    output wire lt,
    output wire gt
);

    assign eq = (a == b);
    assign lt = (a < b);
    assign gt = (a > b);

endmodule