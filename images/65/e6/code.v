module top_module(
    input wire [3:0] b,
    output wire [3:0] result
);

    assign result = b - 4'd5;

endmodule