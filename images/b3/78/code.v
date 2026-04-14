module top_module(
    input wire [5:0] c,
    output wire [5:0] sum
);

    assign sum = c + 6'd10;

endmodule