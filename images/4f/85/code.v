module binary_or(
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [3:0] result
    );

assign result = a | b;

endmodule