module binary_comparator(
    input wire [3:0] a,
    input wire [3:0] b,
    output wire gt,
    output wire lt,
    output wire eq
    );

assign gt = (a > b);
assign lt = (a < b);
assign eq = (a == b);

endmodule