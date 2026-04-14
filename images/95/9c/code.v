module comparator_2bit(
    input wire [1:0] a,
    input wire [1:0] b,
    output wire eq,
    output wire lt,
    output wire gt
);

    assign eq = (a == b);
    assign lt = (a < b);
    assign gt = (a > b);

endmodule